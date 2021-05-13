#!/usr/bin/env bash
set -eou pipefail

echo "Building for $BUILD_TARGET"
cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

source "$cur_dir/helpers.sh"


if [[ $BUILD_TARGET =~ "Windows" ]]; then
  echo "Loading Windows License"
  license="./ci/Unity_v2019.1.12.ulf"
else 
  echo "Loading Unix License"
  license="./ci/Unity_v2019.x.ulf"
fi

load_license "$license.encrypted" "$license.sha1sum" $OPENTIBIA_CRYPT_KEY
export BUILD_PATH=/project/Builds/$BUILD_TARGET/

mkdir -p $BUILD_PATH

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


try apt update && apt install -y zip
try zip -r /project/Builds/${BUILD_TARGET}.zip $BUILD_PATH
