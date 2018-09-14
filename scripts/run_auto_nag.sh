#!/bin/bash
cd ..
echo "`date`: Running RAILS_ENV=production bundle exec rake candidate_mailer:send_notifications from: `pwd`"
RAILS_ENV=production bundle exec rake candidate_mailer:send_notifications
