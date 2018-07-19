require 'fellow_user_matcher'

class User < ApplicationRecord
  devise :database_authenticatable, :cas_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_one :fellow
  
  after_save :attempt_fellow_match, if: :missing_fellow?
  
  def role
    is_admin? ? :admin : :fellow
  end
  
  private

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
