#!/usr/bin/env bash
set -x
echo "Test predefined variables"
echo "Pipeline.Workspace: $(Pipeline.Workspace)"
echo "Build.SourcesDirectory: $(Build.SourcesDirectory)"
echo "System.DefaultWorkingDirectory: $(System.DefaultWorkingDirectory) -- source code files downloaded"
echo "Build.RequestedFor: $(Build.RequestedFor) - Author"
echo "Build.RequestedForId: $(Build.RequestedForId) -- AuthorID"
echo "Build.SourceVersion: $(Build.SourceVersion) -- commitID"
echo "REPO: ${{ parameters.RepoName }}"
echo "TARGET_BR: ${{ parameters.GitOpsBranch }}"
echo "SRC_DIR: ${{ parameters.SourceDirectory }}"
echo "NAMESPACE: ${{ parameters.kubeNamespace }}"
echo "VERSION: ${{ parameters.Version }}"
echo "REVIEWERS: ${{ parameters.Approvers }}"
echo "REQUESTER: $(Build.RequestedFor)"
echo "COMMIT_ID: $(Build.RequestedForId)"
    
#ACCESS_TOKEN: $(System.AccessToken)
echo "ORG: $(System.TeamFoundationCollectionUri)"
#####
echo "Prepare Kubernetes Manifests"
# ...

#####
echo "Set GIT Identity"
git config --global user.email "***phuong***@gmail.com"
git config --global user.name "phuongvo9"
      
echo "Git Checkout branch"
cd $TARGET_REPOS
BRANCH="RANDOM/$(echo $COMMIT_ID | head --bytes 5)-v$(echo $VERSION | tr '.' '-')"
git checkout -b $BRANCH

set +x
## Modify then commit
## Create Pull request
az repos pr create --auto-complete true \
--bypass-policy false \
--delete-source-branch true \
--repository "$TARGET_REPOS" \
--reviewers "${REVIEWERS}" \
--source-branch "${BRANCH}" \
--target-branch "${TARGET_BR}" \
--title "${PR_TITLE}"
--description "${PR_DESCRIPTION}"
[[ $? -eq 1 ]] && git push -d origin "${BRANCH}"
<<ENV
    env:
      REPO: ${{ parameters.RepoName }}
      TARGET_BR: ${{ parameters.GitOpsBranch }}
      SRC_DIR: ${{ parameters.SourceDirectory }}
      NAMESPACE: ${{ parameters.kubeNamespace }}
      VERSION: ${{ parameters.Version }}
      REVIEWERS: ${{ parameters.Approvers }}
      REQUESTER: $(Build.RequestedFor)
      COMMIT_ID: $(Build.SourceVersion)
      ACCESS_TOKEN: $(System.AccessToken)
      ORG: $(System.TeamFoundationCollectionUri)
      AZURE_DEVOPS_EXT_PAT: $(System.AccessToken)
ENV