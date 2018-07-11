class User < ApplicationRecord
  devise :database_authenticatable, :cas_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def password_required?
    false
  end
end
