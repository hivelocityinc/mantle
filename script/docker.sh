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

  docker run -d \
    --name ${CONTAINER_NAME} \
    -u root \
    -p 80:80 \
    -p 3306:3306 \
    ${IMAGE_NAME}:latest

  echo "${GREEN}==> Running image!${CLEAR}"
}

spec() {
  echo "${BLUE}==> Start to image test...${CLEAR}"

  export TARGET_CONTAINER_ID=${CONTAINER_NAME}
  sh ./script/run_test.sh

  echo "${GREEN}==> Finished image test!${CLEAR}"
}

if [ $# -eq 1 ]; then
  case "$1" in
    "clean")
      clean ;;
    "build")
      clean
      build ;;
    "run")
      clean
      build
      run ;;
    "test")
      clean
      build
      run
      spec ;;
  esac
fi

exit 0
