#!/bin/sh

set -e

if [[ ! -z "${DOCKER_USERNAME}" && ! -z "${DOCKER_PASSWORD}" ]]; then
    echo "Authorization credentials was found. Signing...."

    if [[ ! -z "${DOCKER_REGISTRY_URL}" ]]; then
        echo "$DOCKER_PASSWORD" | docker login "$DOCKER_REGISTRY_URL" -u "$DOCKER_USERNAME" --password-stdin
    else
        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    fi

    echo "Successfully signed in to docker registry."

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
else
    echo "::error::Not authorized. Please check if DOCKER_USERNAME and DOCKER_PASSWORD provided. Exiting...."
    exit 1
fi

echo "/usr/local/bin/docker" >> $GITHUB_PATH
