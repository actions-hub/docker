#!/bin/sh

set -e

if [ ! -e "$HOME/.docker/config.json" ] && [ -z "${SKIP_LOGIN}" ]; then
    echo "::error::Not authorized. Please use login action to authorize to registry. Exiting...."
    exit 1
fi

IMAGE_NAME=${NAME}
if [[ -z "${IMAGE_NAME}" ]]; then
    IMAGE_NAME=${GITHUB_REPOSITORY}
fi

IMAGE_TAG=${TAG}
if [[ -z "${IMAGE_TAG}" ]]; then
    IMAGE_TAG=${GITHUB_REF#*/}
    IMAGE_TAG=${IMAGE_TAG#*/}
    IMAGE_TAG=$(echo $IMAGE_TAG | sed -e "s#^v##")

    if [[ "$IMAGE_TAG" == "master" || "$IMAGE_TAG" == "main" ]]; then
        IMAGE_TAG=latest
    fi
fi

echo "IMAGE_TAG=${IMAGE_TAG}" >> $GITHUB_ENV
echo "IMAGE_NAME=${IMAGE_NAME}" >> $GITHUB_ENV

echo "/usr/local/bin/docker" >> $GITHUB_PATH

sh -c "docker $*"
