require 'rails_helper'

RSpec.describe Fellow, type: :model do
  def self.required_attributes
    [:first_name, :last_name]
  end
  
  required_attributes.each do |attribute|
    it { should validate_presence_of(attribute) }
  end
end
