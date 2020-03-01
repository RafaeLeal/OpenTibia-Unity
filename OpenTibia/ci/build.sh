#!/usr/bin/env bash
set -eou pipefail

echo "Building for $BUILD_TARGET"
cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

source "$cur_dir/helpers.sh"

export LOCAL="${LOCAL:-0}"

if [ $LOCAL -eq 1 ]; then 
	export BUILD_PATH="$(pwd)/Builds/$BUILD_TARGET/"
else
  load_license "./ci/Unity_v2019.x.ulf.encrypted" $OPENTIBIA_CRYPT_KEY
  export BUILD_PATH=/project/Builds/$BUILD_TARGET/
fi

mkdir -p $BUILD_PATH
function unity3d_runner() {
  DOCKER_UNITY_EXECUTABLE="/opt/Unity/Editor/Unity"
  ${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' $DOCKER_UNITY_EXECUTABLE} "$@"
}

function build() {
  try_and_continue unity3d_runner -projectPath "$(pwd)" -quit -batchmode -silent-crashes -buildTarget "$BUILD_TARGET" -customBuildTarget "$BUILD_TARGET" -customBuildName "$BUILD_NAME" -customBuildPath "$BUILD_PATH" -logFile /dev/stdout -executeMethod BuildCommand.PerformBuild

  UNITY_EXIT_CODE=$?
}

build || true
sleep 20
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
