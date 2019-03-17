#!/bin/bash

set -e

if [ ! -e Gemfile ]; then
  cp -a $READY_RAILS_DIR/Gemfile .
  touch Gemfile.lock

  bundle install --path vendor/bundle
  bundle exec rails new . -d mysql -f -T --api --skip-bundle

  cp -a $READY_RAILS_DIR/database.yml $READY_RAILS_DIR/puma.rb config/
  cp -a $READY_RAILS_DIR/db_charset_utf8mb4.rb config/initializers/

  mkdir -p tmp/sockets

  rm -r $READY_RAILS_DIR

  rm -rf .bundle
  rm -rf vendor/bundle
  bundle install --path vendor/bundle

  until bundle exec rails db:drop &> /dev/null; do
    >&2 echo "MySQL is unavailable - sleeping"
    sleep 1
  done

  bundle exec rails db:create

elif [ -e $READY_RAILS_DIR ]; then
  bundle install --path vendor/bundle
  rm -r $READY_RAILS_DIR
fi

exec "$@"
