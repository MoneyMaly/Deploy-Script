#!/bin/bash

declare -r rootFolder="/home/moneymaly/Docker-source/"

declare -r projectName="MoneyMaly-User-Service"

declare -r repoName="User-Service"

declare -r gitURLSuffix="MoneyMaly/${repoName}.git"

declare -r exposedPort=8081

# else it uses ssh
declare useHTTPAuth=true

if [ useHTTPAuth ]
then
        declare -r gitURL="https://github.com/${gitURLSuffix}"
else
        declare -r gitURL="git@github.com:${gitURLSuffix}"
fi
cd $rootFolder

rm -fr $repoName

git clone $gitURL

cd "${rootFolder}${repoName}"

git pull origin main

docker build -t $projectName .

docker rm $projectName -f

docker run -d \
        --restart=always \
        -e DATABASE_SERVER=money-maly.mongo.cosmos.azure.com \
        -e DATABASE_PORT=10255 \
        -e DATABASE_NAME=User-Service \
        -e DATABASE_USER=money-maly \
        -e DATABASE_PASSWORD=Ese9uD5DIfrPBPdOWb0Fw50EgPwzuRfr4wRMUvRC89R3PHJjWTpMckWfPfAcj70Y0RTKeRqhPaTouMunoH8LWw== \
        -e APP_SECRET_KEY=09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7 \
        -e ALGORITHM=HS256 \
        -e ACCESS_TOKEN_EXPIRE_MINUTES=120 \
        -p ${exposedPort}:80 --name $projectName $projectName
