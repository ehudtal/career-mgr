class CandidateMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def respond_to_invitation
    set_objects
    
    options = {to: @fellow.contact.email, subject: interpolate(@split.settings['subject'])}
    options.merge!(bcc: Rails.application.secrets.mailer_bcc) if Rails.application.secrets.mailer_bcc

    mail_subscribed(@fellow.receive_opportunities, options)
  end
  
  def notify
    set_objects

    @opportunity_stage = OpportunityStage.find_by(name: params[:stage_name])
    @content = @opportunity_stage.content

    options = {to: @fellow.contact.email, subject: interpolate("#{@opportunity.name}: #{@content['title']}")}
    options.merge!(bcc: Rails.application.secrets.mailer_bcc) if Rails.application.secrets.mailer_bcc

    mail_subscribed(@fellow.receive_opportunities, options)
  end
  
  private
  
  def nag stage_name
    set_stage stage_name
    set_objects

    @content = @opportunity_stage.content

    mail(to: @fellow.contact.email, subject:  interpolate("#{@opportunity.name}: #{@content['title']}"), template_name: 'notify')
  end
  
  def set_objects
    @token = params[:access_token]
    @split = AccessTokenSplit.new(@token, 'invite')
    @fellow_opp = @token.owner
    @fellow = @fellow_opp.fellow
    @opportunity = @fellow_opp.opportunity
    @unsubscriber = @fellow
  end
  
  def interpolate string
    ERB.new(string || '').result(binding).html_safe
  end
end
