#!/usr/bin/env python3
#
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# source: https://github.com/GoogleCloudPlatform/cloud-ops-sandbox/
# -*- coding: utf-8 -*-
"""
This CLI is the interface for sre recipes. It deploys and rolls back
broken services as well as verifies that the user found the correct
cause of the broken service.

For information on how to run the CLI, run the following:
`python3 sandboxctl --help`
"""

import logging
import os
import glob
import signal
import subprocess
import sys

import click

import utils
from recipe_runner import ImplBasedRecipeRunner
from recipe_runner import ConfigBasedRecipeRunner

cli = click.Group()


def get_config_based_recipes():
    files = glob.glob(os.path.join(os.path.dirname(
        os.path.abspath(__file__)), "recipes/configs_based/*.yaml"))
    recipe_names = [os.path.basename(x).split(".")[0] for x in files]
    return recipe_names


def get_impl_based_recipes():
    files = glob.glob(os.path.join(os.path.dirname(
        os.path.abspath(__file__)), "recipes/impl_based/*recipe*.py"))
    recipe_names = [os.path.basename(x).split(".")[0] for x in files]
    return recipe_names


CONFIG_RECIPES = get_config_based_recipes()
IMPL_RECIPES = get_impl_based_recipes()


@cli.command()
@click.argument('action', type=click.Choice(
    ['break', 'restore', 'verify', 'hint']))
@click.argument('recipe_name', type=click.Choice(
    sorted(CONFIG_RECIPES + IMPL_RECIPES)))
@click.option('--skip-loadgen', is_flag=True, help="Ignore loadgen actions in config based recipes.")
def sre_recipes(action, recipe_name, skip_loadgen):
    """Performs an action on a recipe."""
    logging.basicConfig(filename='srerecipes.log', level=logging.INFO,
                        format='%(asctime)s %(message)s')

    try:
        has_config = recipe_name in CONFIG_RECIPES
        has_impl = recipe_name in IMPL_RECIPES

        recipe = None
        if has_config and has_impl:
            print(f"Find conflicting config & impl for {recipe_name}")
            return
        elif has_config:
            recipe = ConfigBasedRecipeRunner(recipe_name, skip_loadgen=skip_loadgen)
        elif has_impl:
            recipe = ImplBasedRecipeRunner(recipe_name)
        else:
            # should not reach here due to 'click.Choice' above
            print(f"Cannot find config or impl for {recipe_name}")
            return

        if action == 'break':
            logging.info(f"Breaking {recipe_name}")
            recipe.run_break()
        elif action == 'restore':
            logging.info(f"Restoring {recipe_name}")
            recipe.run_restore()
        elif action == 'verify':
            logging.info(f"Verifying {recipe_name}")
            recipe.run_verify()
        elif action == 'hint':
            logging.info(f"Giving hint for {recipe_name}")
            recipe.run_hint()
    except Exception as e:
        logging.error(e)
        print(f"Failed to run SRE Recipe {recipe_name}: {e}")
        exit(1)


@cli.command()
@click.argument('traffic_pattern', type=click.Choice(['basic', 'step']))
def loadgen(traffic_pattern):
    """Change traffic patterns for the loadgenerator service"""
    #We will always switch back to cloud-ops-sandbox cluster after successful
    #completion of this command, assuming it is the most common cluster to be in.
    set_env_command = "kubectl set env deployment/loadgenerator "\
        f"LOCUST_TASK={traffic_pattern}"
    delete_pods_command = "kubectl delete pods -l app=loadgenerator"

    if not utils.auth_cluster('loadgenerator'):
        print("Failed to authenticate into load generator cluster")
        return
    print('Redeploying Loadgenerator...')
    _, err = utils.run_shell_command(set_env_command)
    if err:
        print("Failed to set traffic pattern for load generator: ", err)
    _, err = utils.run_shell_command(delete_pods_command)
    if err:
        print("Failed to redeploy updated load generator: ", err)
    print(f'Loadgenerator deployed using {traffic_pattern} pattern')
    ip_addr, err = utils.get_loadgen_ip()
    if err:
        print("Failed to get load generator IP: ", err)
    elif not ip_addr:
        print("Found empty load generator IP")
    else:
        print(f"Loadgenerator web UI: http://{ip_addr}")

    # Try switching back to cloud-ops-sandbox cluster.
    # Do not error even if we fail
    utils.auth_cluster('cloud-ops-sandbox')


@cli.command()
@click.option('--project', '-p', default=None,
              help='GCP project to deploy Cloud Operations Sandbox to')
@click.option('--verbose', '-v', default=False, is_flag=True,
              help='print commands as they run (set -x)')
@click.option('--skip-loadgenerator', default=False,  is_flag=True,
              help="Don't deploy a loadgenerator instance")
@click.option('--service-wait', default=False,  is_flag=True,
              help='Wait indefinitely for services to be detected by Cloud Monitoring')
def create(project, *args, **kwargs):
    """Create a new sandbox"""
    os.chdir(os.path.abspath(sys.path[0]))
    command = "../terraform/install.sh"
    # add optional project argument
    if project:
        command += f' --project {project}'
    # add flags passed in to function
    for (arg, value) in kwargs.items():
        if value:
            command += f' --{arg.replace("_", "-")}'
    os.setpgrp()
    complete = False
    try:
        # run install.sh in a background shell
        process = subprocess.Popen(command, bufsize=0, shell=True)
        process.communicate()
        complete = True
    finally:
        # kill background process if script is terminated
        if not complete:
            os.killpg(0, signal.SIGTERM)


@cli.command()
def describe():
    """Show information about an existing sandbox"""
    gcp_path = "https://console.cloud.google.com"
    project_id, err = utils.get_project_id()
    if err:
        print("Failed to get project ID:". err)
    external_ip, err = utils.get_external_ip()
    if err:
        print("Failed to get external ID:". err)
    loadgen_ip, err = utils.get_loadgen_ip()
    if err:
        print("Failed to get loadgen ID:". err)
    gcp_kubernetes_path = gcp_path + '/kubernetes/workload?project=' + project_id
    gcp_monitoring_path = gcp_path + '/monitoring?project=' + project_id
    print(f"""Cloud Operations Sandbox info for project: {project_id}
    - Load generator web interface: http://{loadgen_ip}
    - Hipstershop web app address: http://{external_ip}
    - Google Cloud Console KBE Dashboard: {gcp_kubernetes_path}
    - Google Cloud Console Monitoring Workspace {gcp_monitoring_path}""")


@cli.command()
def destroy():
    """Delete an existing sandbox"""
    os.chdir(os.path.abspath(sys.path[0]))
    destroy_command = "../terraform/destroy.sh"
    utils.run_interactive_shell_command(destroy_command)


if __name__ == "__main__":
    cli()
