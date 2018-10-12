class AdminMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  
  def application_submitted
    @fellow_opportunity = params[:fellow_opportunity]
    @fellow = @fellow_opportunity.fellow
    @opportunity = @fellow_opportunity.opportunity
    
    direct_mail(to: @opportunity.referral_email, subject: "#{@fellow.first_name} Submitted an Application")
  end
end
