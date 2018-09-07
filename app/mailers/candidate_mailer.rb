class CandidateMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def respond_to_invitation
    set_objects
    mail(to: @fellow.contact.email, subject: "#{@opp.name} matches your career profile")
  end
  
  def notify
    set_objects

    @opportunity_stage = OpportunityStage.find_by(name: params[:stage_name])
    @content = @opportunity_stage.content

    mail(to: @fellow.contact.email, subject: "#{@opp.name}: #{@content['title']}")
  end
  
  private
  
  def nag stage_name
    set_stage stage_name
    set_objects

    @content = @opportunity_stage.content

    mail(to: @fellow.contact.email, subject: "#{@opp.name}: #{@content['title']}", template_name: 'notify')
  end
  
  def set_objects
    @token = params[:access_token]
    @fellow_opp = @token.owner
    @fellow = @fellow_opp.fellow
    @opp = @fellow_opp.opportunity
  end
end
