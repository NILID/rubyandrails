#!/bin/bash

#~/init.d/mongrel restart production
cd ~/http
# bundle exec puma restart -e production
# RAILS_ENV=production bundle exec puma -C config/puma.rb config.ru -d

#~/init.d/mongrel start production
killall -9 ruby

~/init.d/mongrel restart production
