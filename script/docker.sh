#!/bin/bash

set -e

CONTAINER_NAME="mantle"
IMAGE_NAME="hivelocityinc/"${CONTAINER_NAME}
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CLEAR='\033[0m'

clean() {
  echo "${BLUE}==> Start to clean up...${CLEAR}"

  docker kill ${CONTAINER_NAME} > /dev/null 2>&1 || true
  docker rm   ${CONTAINER_NAME} > /dev/null 2>&1 || true
  docker rmi  ${IMAGE_NAME} > /dev/null 2>&1 || true

  echo "${GREEN}==> Finished clean up!${CLEAR}"
}

build() {
  echo "${BLUE}==> Start to build image...${CLEAR}"

  docker build -t ${IMAGE_NAME} .

  echo "${GREEN}==> Finished build image!${CLEAR}"
}

run() {
  echo "${BLUE}==> Start to run container...${CLEAR}"

  docker run \
    -d \
    --name ${CONTAINER_NAME} \
    -p 80:80 \
    ${IMAGE_NAME}:latest

  echo "${GREEN}==> Running image!${CLEAR}"
}

spec() {
  echo "${BLUE}==> Start to image test...${CLEAR}"

  bundle exec rake

  echo "${GREEN}==> Finished image test!${CLEAR}"
}

if [ $# -eq 1 ]; then
  if [ $1 = "clean" ]; then
    clean
  fi

  if [ $1 = "build" ]; then
    clean
    build
  fi

  if [ $1 = "run" ]; then
    clean
    build
    run
  fi

  if [ $1 = "test" ]; then
    spec
  fi

  if [ $1 = "all" ]; then
    clean
    build
    run
    spec
  fi
fi

exit 0
