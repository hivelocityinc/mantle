#!/bin/bash

for i in {30..0}; do
  if docker exec ${TARGET_CONTAINER_ID} ps | grep supervisord &> /dev/null; then
    break
  fi
  echo "[${i}] supervidord process is not working..."
  sleep 1
done

if [ "$i" = 0 ]; then
	echo >&2 'supervidord process failed.'
	exit 1
fi

bundle exec rake
