class Cohort < ApplicationRecord
  has_one :contact, as: :contactable

  belongs_to :course
  
  has_many :cohort_fellows

  has_many :fellows, through: :cohort_fellows do
    def create_or_update attributes
      employment_status = EmploymentStatus.order('position asc').first
      anywhere = Metro.find_by name: 'Anywhere'

      contact_attributes = attributes.slice(*Contact.attribute_names.map(&:to_sym))
      cohort_fellow_attributes = attributes.slice(*CohortFellow.attribute_names.map(&:to_sym))

      fellow_attribute_keys = attributes.keys - contact_attributes.keys - cohort_fellow_attributes.keys
      fellow_attributes = attributes.slice(*fellow_attribute_keys).merge(
        employment_status_id: employment_status.id
      )
      
      begin
        if fellow = unique(attributes)
          fellow.update fellow_attributes
          fellow.contact.update contact_attributes
        else
          fellow = create fellow_attributes.merge({
            contact_attributes: contact_attributes
          })
        end

        fellow.add_metro(fellow.default_metro)
        fellow.add_metro(anywhere)

        proxy_association.owner.cohort_fellows.find_or_create_by(fellow_id: fellow.id).update(cohort_fellow_attributes)
      rescue ActiveRecord::RecordInvalid
        return nil
      end
      
      fellow
    end
    
    def unique attributes
      detect do |fellow|
        fellow_attrs = {first_name: fellow.first_name, last_name: fellow.last_name, phone: fellow.contact.phone, email: fellow.contact.email}
      
        hashes_equal(attributes, fellow_attrs, [:phone, :email]) ||
        hashes_equal(attributes, fellow_attrs, [:phone, :first_name, :last_name]) ||
        hashes_equal(attributes, fellow_attrs, [:email, :first_name, :last_name])
      end
    end

    def hashes_equal first, second, attributes
      first.slice(*attributes) == second.slice(*attributes)
    end
  end
  
  has_and_belongs_to_many :coaches
  
  validates :name, presence: true, uniqueness: {scope: :course_id}
end
