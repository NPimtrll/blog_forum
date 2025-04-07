#!/bin/bash
set -e

# Write RAILS_MASTER_KEY to config/master.key if it doesn't exist
if [ -n "$RAILS_MASTER_KEY" ] && [ ! -f config/master.key ]; then
    echo "$RAILS_MASTER_KEY" > config/master.key
fi

rm -f /rails/tmp/pids/server.pid
bundle exec rails db:migrate

exec "$@"
