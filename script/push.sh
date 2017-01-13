#!/bin/bash

set -e

if [ "${TRAVIS_BRANCH}" == "master" ] && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
  docker tag hivelocityinc/mantle:latest hivelocityinc/mantle:php7
  docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
  docker push hivelocityinc/mantle:latest
  docker push hivelocityinc/mantle:php7
fi