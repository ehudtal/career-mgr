require 'fellow_user_matcher'

class User < ApplicationRecord
  ADMIN_DOMAIN_WHITELIST = ['bebraven.org']
  
  devise :database_authenticatable, :cas_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_one :fellow
  
  before_create :attempt_admin_set, unless: :is_admin?
  after_save :attempt_fellow_match, if: :missing_fellow?
  
  def role
    if is_admin?
      :admin
    elsif is_fellow?
      :fellow
    else
      nil
    end
  end
  
  private

  def attempt_admin_set
    return if email.nil?
    return if FellowUserMatcher.match?(email)
    
    domain = email.split('@').last
    self.is_admin = ADMIN_DOMAIN_WHITELIST.include?(domain)
  end
  
  def attempt_fellow_match
    FellowUserMatcher.match(email)
  end

  def missing_fellow?
    fellow.nil?
  end
  
  def password_required?
    false
  end
end
