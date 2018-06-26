class Cohort < ApplicationRecord
  has_one :contact, as: :contactable

  belongs_to :course
  
  has_many :cohort_fellows
  has_many :fellows, through: :cohort_fellows
  
  has_and_belongs_to_many :coaches
  
  validates :name, presence: true, uniqueness: {scope: :course_id}

  def unique_fellow attributes
    fellows.detect do |fellow|
      fellow_attrs = {first_name: fellow.first_name, last_name: fellow.last_name, phone: fellow.contact.phone, email: fellow.contact.email}
      
      hashes_equal(attributes, fellow_attrs, [:phone, :email]) ||
      hashes_equal(attributes, fellow_attrs, [:phone, :first_name, :last_name]) ||
      hashes_equal(attributes, fellow_attrs, [:email, :first_name, :last_name])
    end
  end

  private
  
  def hashes_equal first, second, attributes
    first.slice(*attributes) == second.slice(*attributes)
  end
end
