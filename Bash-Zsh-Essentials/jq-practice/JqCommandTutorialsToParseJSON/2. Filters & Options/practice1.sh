#!/bin/bash
hostName=44.204.49.249
userName=$(curl -s -X GET http://192.168.0.110:8080/secrets | jq -r .secrets.remoteServerCreds.userName)
password=$(curl -s -X GET http://192.168.0.110:8080/secrets | jq -r .secrets.remoteServerCreds.password)
echo ${userName}
echo ${password}
sshpass -p ${password} ssh $userName@$hostName 'df -h'
