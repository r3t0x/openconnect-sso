#!/usr/bin/env bash

set -e

usage() {
    echo "Usage: $(basename $0)"
    echo "   -s  Skips building the image again"
    echo "   -D  Deletes the image after building"
}
SKIP_BUILD=false
DELETE_IMAGE=false
while getopts 'sDh' opt; do
    case "$opt" in
        s)
            SKIP_BUILD=true
            ;;
        D)
            DELETE_IMAGE=true
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if $SKIP_BUILD; then
    echo "... Skipping image build ..."
else
    # build the image
    podman build -t oc-sso .
fi

mkdir ./dist -p

# run the image
podman run --rm -v "$(pwd)/dist":/app/dist oc-sso:latest

if $DELETE_IMAGE; then
    podman rmi --force oc-sso
fi
