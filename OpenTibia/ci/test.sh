#!/usr/bin/env bash
set -eou pipefail

echo "Testing for $TEST_PLATFORM"
cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

source "$cur_dir/helpers.sh"

license="./ci/Unity_v2019.x.ulf"
load_license "$license.encrypted" "$license.sha1sum" $OPENTIBIA_CRYPT_KEY

try_and_continue unity3d_runner -projectPath $(pwd) -runTests -testPlatform $TEST_PLATFORM -testResults $(pwd)/$TEST_PLATFORM-results.xml -logFile /dev/stdout -batchmode

UNITY_TEST_EXIT_CODE=$?

if [ $UNITY_TEST_EXIT_CODE -eq 0 ]; then
  echo "Run succeeded, no failures occurred";
elif [ $UNITY_TEST_EXIT_CODE -eq 2 ]; then
  echo "Run succeeded, some tests failed";
elif [ $UNITY_TEST_EXIT_CODE -eq 3 ]; then
  echo "Run failure (other failure)";
else
  echo "Unexpected exit code $UNITY_TEST_EXIT_CODE";
fi

cat $(pwd)/$TEST_PLATFORM-results.xml | grep test-run | grep Passed
exit $UNITY_TEST_EXIT_CODE
