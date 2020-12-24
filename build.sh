#!/bin/bash

VERSION=latest
IMAGE=qnimbus/youtube-dl

export DOCKER_CLI_EXPERIMENTAL="enabled"

# Build latest
docker build -t ${IMAGE}:${VERSION} --compress --no-cache --platform linux/amd64 . || exit 1

build_version=$(docker run --rm ${IMAGE}:${VERSION} | grep -oP '(?<=youtube-dl version: )[\d\.]+$' || exit 1)

if [ -z "${build_version}" ]; then
    echo "Failed when trying to get youtube-dl version in latest container :("
    exit 1
fi

# If the build was successful, then we can tag with current version
docker tag ${IMAGE}:${VERSION} ${IMAGE}:"${build_version}"
