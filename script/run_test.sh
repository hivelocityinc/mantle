#!/bin/bash

sleep 1

echo "wait supervisord process..."
for i in {30..0}; do
  if docker exec "${TARGET_CONTAINER_ID}" ps | grep supervisord &> /dev/null; then
    break
  fi
  echo "[${i}] supervidord process still not working..."
  sleep 1
done

if [ "$i" = 0 ]; then
	echo >&2 'supervidord process failed.'
	exit 1
fi

echo "start serverspec testing..."
bundle exec rake
