#!/usr/bin/env bash
set -eou pipefail

echo "Building for $BUILD_TARGET"
cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

source "$cur_dir/helpers.sh"


if [[ $BUILD_TARGET =~ "Windows" ]]; then
  echo "Loading Windows License"
  load_license "./ci/Unity_v2019.1.12.ulf.encrypted" $OPENTIBIA_CRYPT_KEY
else 
  echo "Loading Unix License"
  load_license "./ci/Unity_v2019.x.ulf.encrypted" $OPENTIBIA_CRYPT_KEY
fi

export BUILD_PATH=/project/Builds/$BUILD_TARGET/

mkdir -p $BUILD_PATH
function unity3d_runner() {
  DOCKER_UNITY_EXECUTABLE="/opt/Unity/Editor/Unity"
  ${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' $DOCKER_UNITY_EXECUTABLE} "$@"
}

function build() {
  try unity3d_runner -projectPath "$(pwd)" -quit -batchmode -silent-crashes -buildTarget "$BUILD_TARGET" -customBuildTarget "$BUILD_TARGET" -customBuildName "$BUILD_NAME" -customBuildPath "$BUILD_PATH" -logFile /dev/stdout -executeMethod BuildCommand.PerformBuild

  UNITY_EXIT_CODE=$?
}

build

if [ $UNITY_EXIT_CODE -eq 0 ]; then
  echo "Run succeeded, no failures occurred";
elif [ $UNITY_EXIT_CODE -eq 2 ]; then
  echo "Run succeeded, some tests failed";
elif [ $UNITY_EXIT_CODE -eq 3 ]; then
  echo "Run failure (other failure)";
else
  echo "Unexpected exit code $UNITY_EXIT_CODE";
fi

try ls -la /project/Builds/
try ls -la $BUILD_PATH
[ -n "$(ls -A $BUILD_PATH)" ] # fail job if build folder is empty
