require 'fellow_user_matcher'

class User < ApplicationRecord
  devise :database_authenticatable, :cas_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_one :fellow
  
  after_save :attempt_fellow_match, if: :missing_fellow?
         
  def password_required?
    false
  end
  
  private
  
  def missing_fellow?
    fellow.nil?
  end

  def attempt_fellow_match
    FellowUserMatcher.match(email)
  end
end
