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

function unity3d_runner() {
  DOCKER_UNITY_EXECUTABLE="/opt/Unity/Editor/Unity"
  ${UNITY_EXECUTABLE:-xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' $DOCKER_UNITY_EXECUTABLE} "$@"
}

function load_license() {
    local license_encrypted_filepath=$1
    local license_sha1sum=$2
    local encryption_key=$3
    openssl enc -aes-256-cbc -d -in $license_encrypted_filepath -k $encryption_key > Unity_v2019.x.ulf
    export UNITY_LICENSE_CONTENT="$(cat Unity_v2019.x.ulf)"

    mkdir -p ~/.cache/unity3d
    mkdir -p ~/.local/share/unity3d/Unity/
    mv Unity_v2019.x.ulf "$HOME/.local/share/unity3d/Unity/Unity_lic.ulf"
    sha1sum -c $license_sha1sum 
}
