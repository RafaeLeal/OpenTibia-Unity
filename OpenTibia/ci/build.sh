#!/usr/bin/env bash
#set -eou pipefail
set -e
set -x

echo "Building for $BUILD_TARGET"
cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

echo $cur_dir
source "$cur_dir/helpers.sh"

echo $(echo $UNITY_LICENSE_CONTENT | wc -c)
export LOCAL="${LOCAL:-0}"

if [ $LOCAL -eq 1 ]; then 
	export BUILD_PATH="$(pwd)/Builds/$BUILD_TARGET/"
else
  load_license "./ci/Unity_v2019.x.ulf.encrypted"
	export BUILD_PATH=/project/Builds/$BUILD_TARGET/
fi

mkdir -p $BUILD_PATH

${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' /opt/Unity/Editor/Unity} \
  -projectPath $(pwd) \
  -quit \
  -batchmode \
  -username "$UNITY_EMAIL" \
  -password "$UNITY_PASSWORD" \
  -buildTarget $BUILD_TARGET \
  -customBuildTarget $BUILD_TARGET \
  -customBuildName $BUILD_NAME \
  -customBuildPath $BUILD_PATH \
  -executeMethod BuildCommand.PerformBuild \
  -logFile /dev/stdout

UNITY_EXIT_CODE=$?

if [ $UNITY_EXIT_CODE -eq 0 ]; then
  echo "Run succeeded, no failures occurred";
elif [ $UNITY_EXIT_CODE -eq 2 ]; then
  echo "Run succeeded, some tests failed";
elif [ $UNITY_EXIT_CODE -eq 3 ]; then
  echo "Run failure (other failure)";
else
  echo "Unexpected exit code $UNITY_EXIT_CODE";
fi

ls -la $BUILD_PATH
[ -n "$(ls -A $BUILD_PATH)" ] # fail job if build folder is empty
