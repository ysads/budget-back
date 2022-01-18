#!/bin/sh
set -e

rm -rf /web/tmp/pids/server.pid

bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails s -b 0.0.0.0 -p 3000