#!/bin/bash

set -e

bundle check || bundle install --binstubs="$BUNDLE_BIN"
rm -f /myapp/tmp/pids/server.pid

exec "$@"
