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

function try_and_continue() {
    echo "$ $@" 1>&2; "$@" || yell "cannot $*";
}

function load_license() {
    local license_encrypted_filepath=$1
    local encryption_key=$2
    openssl enc -aes-256-cbc -d -in $license_encrypted_filepath -k $encryption_key > Unity_v2019.x.ulf
    export UNITY_LICENSE_CONTENT="$(cat Unity_v2019.x.ulf)"
    cat Unity_v2019.x.ulf | sha1sum -c ./ci/unity_lic.sha1sum

    mkdir -p ~/.cache/unity3d
    mkdir -p ~/.local/share/unity3d/Unity/
    export LICENSE_FILE="$HOME/.local/share/unity3d/Unity/Unity_lic.ulf"
    mv Unity_v2019.x.ulf $LICENSE_FILE
}
