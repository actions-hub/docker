#!/bin/sh

set -e

if [ ! -e "$HOME/.docker/config.json" ]; then
    echo "::error::Not authorized. Please use login action to authorize to registry. Exiting...."
    exit 1
fi

if [[ -z "${IMAGE_NAME}" ]]; then
    IMAGE_NAME=${GITHUB_REPOSITORY}
fi

if [[ ! -z "${IMAGE_TAG}" ]]; then
    IMAGE_TAG=${GITHUB_REF#*/}
    IMAGE_TAG=${IMAGE_TAG#*/}
    IMAGE_TAG=$(echo $IMAGE_TAG | sed -e "s#^v##")
else
    IMAGE_TAG=latest
fi

echo ::set-output name=IMAGE_TAG::${IMAGE_TAG}
echo ::set-output name=IMAGE_NAME::${IMAGE_NAME}

echo ::add-path::/usr/local/bin/docker

sh -c "docker $*"