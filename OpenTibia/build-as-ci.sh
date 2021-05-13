#!/usr/bin/env bash

# set -euo pipefail

#export UNITY_EXECUTABLE=${UNITY_EXECUTABLE:-"/Applications/Unity/Hub/Editor/2019.1.8f1/Unity.app/Contents/MacOS/Unity"}
export BUILD_NAME=${BUILD_NAME:-"OpenTibia-Unity-LEAL"}
#export LOCAL=1
#BUILD_TARGET=StandaloneLinux64 
export BUILD_TARGET=StandaloneOSX 
#BUILD_TARGET=StandaloneWindows64
#BUILD_TARGET=WebGL 
IMAGE_NAME="gableroux/unity3d:2019.1.8f1-mac-add-2017-4-29f1-2018-4-3f1-2019-1-8f1"
docker run \
  -e BUILD_NAME \
  -e BUILD_TARGET \
  -e OPENTIBIA_CRYPT_KEY \
  -w /project/ \
  -it \
  -v $(pwd):/project/ \
  $IMAGE_NAME \
  /bin/bash -c "./ci/build.sh"
