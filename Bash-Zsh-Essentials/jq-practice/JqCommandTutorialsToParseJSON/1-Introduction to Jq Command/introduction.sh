#!/bin/bash
userName=ec2-user
password=ec2-user@123

hostName=44.204.49.249
echo "userName is: ${userName}"
echo "password is: ${password}"

echo "Finding File System Usage on remote server: ${hostName} "
sshpass -p ${password} ssh ${userName}@${hostName} 'df -h'