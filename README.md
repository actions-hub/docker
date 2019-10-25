# docker

[![Docker](https://serhiy.s3.eu-central-1.amazonaws.com/Github_repo/docker/horizontal-logo-monochromatic-white.png)](https://www.docker.com)

GitHub Action with docker cli.

## Usage
```bash
- name: Login to docker hub
  uses: actions-hub/docker/login@master
  env:
    DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
    DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}

- name: Build :latest
  run: docker build -t ${GITHUB_REPOSITORY}:latest .

- name: Push to docker hub :latest
  uses: actions-hub/docker/cli@master
  with:
    args: push ${GITHUB_REPOSITORY}:latest
```

## Actions

This repository contains 2 actions:  

- [login](https://github.com/actions-hub/docker/tree/master/login)
- [cli](https://github.com/actions-hub/docker/tree/master/cli)

## Example

### Latest
```bash
name: Docker registry

on: [push]

jobs:
  github:
    runs-on: ubuntu-latest    
    steps:
      - uses: actions/checkout@v1

      - name: Login to github registry
        uses: actions-hub/docker/login@master
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
          DOCKER_REGISTRY_URL: docker.pkg.github.com

      - name: Build :lastest
        if: success()
        run: docker build -t docker.pkg.github.com/${{ github.repository }}/app:latest .
        
      - name: Push to docker hub :latest
        if: success()
        uses: actions-hub/docker/cli@master
        with:
          args: push docker.pkg.github.com/${{ github.repository }}:latest
```

### Tag
```bash
name: Docker registry

on: 
   push:
     tags:
       - 'v*'

jobs:
  github:
    runs-on: ubuntu-latest    
    steps:
      - uses: actions/checkout@v1

      - name: Login to github registry
        uses: actions-hub/docker/login@master
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
          DOCKER_REGISTRY_URL: docker.pkg.github.com

      - name: Build :tag
        if: success()
        run: docker build -t docker.pkg.github.com/${{ github.repository }}/app:${IMAGE_TAG} .

      - name: Push to docker hub :tag
        if: success()
        uses: actions-hub/docker/cli@master
        with:
          args: push docker.pkg.github.com/${{ github.repository }}:${IMAGE_TAG}
```

### Universal
```bash
name: Deploy to docker hub

on:
   push:
     branches:    
      - master
     tags:
       - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@master

      - name: Login to docker hub
        if: success()
        uses: actions-hub/docker/login@master
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build image
        if: success()
        run: docker build -t ${GITHUB_REPOSITORY}:${IMAGE_TAG} .

      - name: Push to docker registry
        if: success()
        uses: actions-hub/docker/cli@master
        with:
          args: push ${GITHUB_REPOSITORY}:${IMAGE_TAG}
```

## Licence
[MIT License](https://github.com/actions-hub/docker/blob/master/LICENSE)
