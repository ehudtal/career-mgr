#!/bin/bash
cd ..
RAILS_ENV=production bundle exec rake candidate_mailer:send_notifications
