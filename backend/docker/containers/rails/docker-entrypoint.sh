#!/bin/bash

set -e
if [ ! -e vendor ]; then
  mkdir -p tmp/sockets
  bundle install --path vendor/bundle

  until bundle exec rails db:drop &> /dev/null; do
    >&2 echo "MySQL is unavailable - sleeping"
    sleep 1
  done

  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
else
  bundle install --path vendor/bundle
fi

exec "$@"
