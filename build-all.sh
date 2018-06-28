#!/bin/sh

HERE=$(realpath $(dirname $0))
BUILD_PATH="${HERE}/.builds"

failed() {
    status=$?
    lineno=$1
    msg=$2
    echo ":$lineno Failed $msg" >&2
    exit $status
}

main() {
    export PKGDEST=$BUILD_PATH
    export IFS='
'

    cd $HERE \
        && mkdir -p $BUILD_PATH || failed $LINENO "to create build directory"

    local packages=$(find . -maxdepth 1 -type d -not -path '*\/.*' -and -not -path '.')

    for pkg in $packages; do
        echo "Building: $pkg" >&2
    
        cd $pkg && makepkg -sfr --noconfirm || failed $LINENO "to build $pkg"

        cd ..
    done
}

main

