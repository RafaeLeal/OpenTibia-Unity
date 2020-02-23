#!/usr/bin/env bash
set -eou pipefail

function yell() {
    echo "[$0]: $*" >&2
}

function die() {
    yell "$*"; exit 111;
}

function try() {
    echo "$ $@" 1>&2; "$@" || die "cannot $*";
}

function load_license() {
    local license_encrypted_filepath=$1
    openssl aes-256-cbc -md md5 -d -in $license_encrypted_filepath -out Unity_v2019.x.ulf -k $OPENTIBIA_CRYPT_KEY
    export UNITY_LICENSE_CONTENT="$(cat Unity_v2019.x.ulf)"
    rm Unity_v2019.x.ulf
}

function before_script() {
    set -x
    mkdir -p /root/.cache/unity3d
    mkdir -p /root/.local/share/unity3d/Unity/
    set +x

    UPPERCASE_BUILD_TARGET=${BUILD_TARGET^^};

    if [ $UPPERCASE_BUILD_TARGET = "ANDROID" ]
    then
        if [ -n $ANDROID_KEYSTORE_BASE64 ]
        then
            echo '$ANDROID_KEYSTORE_BASE64 found, decoding content into keystore.keystore'
            echo $ANDROID_KEYSTORE_BASE64 | base64 --decode > keystore.keystore
        else
            echo '$ANDROID_KEYSTORE_BASE64'" env var not found, building with Unity's default debug keystore"
        fi
    fi

    echo "Writing UNITY_LICENSE_CONTENT to license file /root/.local/share/unity3d/Unity/Unity_lic.ulf"
    echo "$UNITY_LICENSE_CONTENT" | tr -d '\r' > /root/.local/share/unity3d/Unity/Unity_lic.ulf

    set -x

}