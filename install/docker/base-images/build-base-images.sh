#!/bin/bash
##########################################################################
# AutoML for eyeCloudAI 3.1 build docker images
# Author : Jin Kim
# e-mail : jinkim@seculayer.com
# Powered by Seculayer © 2021 AI Service Model Team, R&D Center of Seculayer Inc.
##########################################################################
BASE_DIR=
EXEC_FILE="$0"
BASE_NAME=$(basename "$EXEC_FILE")
if [ "$EXEC_FILE" = "./$BASE_NAME" ] || [ "$EXEC_FILE" = "$BASE_NAME" ]; then
  BASE_DIR=$(pwd)
else
  BASE_DIR=$(echo "$EXEC_FILE" | sed 's/'"\/${BASE_NAME}"'$//')
fi
##########################################################################
source "${BASE_DIR}"/../../conf/ape.conf

# JAVA 11 base image
if [ "${IS_PRIVATE_NETWORK}" = "false" ]
then
  docker build -f ./java11/Dockerfile -t $REGISTRY_URL/ape/java-base:$JAVA_VER ./java11
fi
docker push $REGISTRY_URL/ape/java-base:$JAVA_VER

# python3.7
if [ "${IS_PRIVATE_NETWORK}" = "false" ]
then
  docker build -f ./py3.7-cv2/Dockerfile -t $REGISTRY_URL/ape/python-base:$PYTHON_VER ./py3.7-cv2
fi
docker push $REGISTRY_URL/ape/python-base:$PYTHON_VER

# python3.7 with CUDA & cuDNN
if [ "${GPU_USE}" == "true" ]
then
  if [ "${IS_PRIVATE_NETWORK}" = "false" ]
  then
    docker build -f ./py3.7-cuda11.2-cv2/Dockerfile -t $REGISTRY_URL/ape/python-base-gpu:$PYTHON_VER ./py3.7-cuda11.2-cv2
  fi
  docker push $REGISTRY_URL/ape/python-base-gpu:$PYTHON_VER
fi

# DB client
if [ "${IS_PRIVATE_NETWORK}" = "false" ]
then
  docker build -f ./db-client/Dockerfile -t $REGISTRY_URL/ape/db-client:1.0.0 ./db-client
fi
docker push $REGISTRY_URL/ape/db-client:1.0.0
