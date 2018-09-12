module CandidateNotifier
  MAILER_FREQUENCY = 24
  
  class << self
    def send_notifications
      FellowOpportunity.active.where("last_contact_at < ?", MAILER_FREQUENCY.hours.ago).each do |candidate|
        access_token = AccessToken.for(candidate)
        
        case candidate.stage
        when 'respond to invitation'
          CandidateMailer.with(access_token: access_token).respond_to_invitation.deliver_later
        else
          CandidateMailer.with(access_token: access_token, stage_name: candidate.stage).notify.deliver_later
        end
        
        candidate.update last_contact_at: Time.now
      end
    end
  end
end