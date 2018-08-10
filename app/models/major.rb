class Major < ApplicationRecord
  has_and_belongs_to_many :fellows
  has_and_belongs_to_many :opportunities

  belongs_to :parent, class_name: 'Major', optional: true
  has_many :children, class_name: 'Major', foreign_key: 'parent_id'
  
  validates :name, presence: true, uniqueness: true
  
  class << self
    def load_from_yaml
      destroy_all
      
      data = YAML.load(File.read("#{Rails.root}/config/majors.yml"))
      
      data.each do |category, major_names|
        category = Major.create name: category
        next if major_names.nil?

        major_names.each do |major_name|
          Major.create name: major_name, parent: category
        end
      end
    end
  end
  
  def all_parents
    return [] if parent.nil?
    ([parent] + parent.all_parents).compact
  end
  
  def all_children
    return [] if children.empty?
    (children + children.map(&:all_children).flatten).compact
  end
end
