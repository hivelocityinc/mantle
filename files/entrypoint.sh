#!/bin/bash

set -e

exec /usr/bin/supervisord --nodaemon -c /etc/supervisord.conf
