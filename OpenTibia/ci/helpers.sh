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
    export UNITY_LICENSE_CONTENT=`cat Unity_v2019.x.ulf`
    rm Unity_v2019.x.ulf
}