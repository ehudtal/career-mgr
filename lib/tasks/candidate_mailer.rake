require 'candidate_notifier'

namespace :candidate_mailer do
  desc "Send notifications for any fellow opportunities that require it"
  task send_notifications: :environment do
    CandidateNotifier.send_notifications
  end
end
