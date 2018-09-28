class Metro < ApplicationRecord
  has_and_belongs_to_many :opportunities
  has_and_belongs_to_many :fellows
  
  has_and_belongs_to_many :parents, class_name: 'Metro', join_table: 'metro_relationships', foreign_key: 'parent_id', association_foreign_key: 'child_id'
  has_and_belongs_to_many :children, class_name: 'Metro', join_table: 'metro_relationships', foreign_key: 'child_id', association_foreign_key: 'parent_id'

  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: true
  
  scope :city, ->{ where.not(source: ['ST', 'ANY']) }
  scope :state, ->{ where(source: 'ST') }

  class << self
    def load_txt filename
      delete_all
    
      attributes = []
      
      lines = if File.exists?(filename)
        File.readlines(filename)
      else
        $stdin.readlines
      end
      
      lines.each do |line|
        fields = line.chomp.split("\t")
        
        code = fields[0].strip
        name = fields[1].strip.gsub(/,\s*/, ', ')
        source = fields[2].strip
        state = name.split(', ')[1]
        
        attributes << {code: code, name: name, source: source, state: state}
      end
        
      create attributes
    end
  end
  
  def states
    city, state_list = name.split(/,\s*/)
    return [] if state_list.nil?
    
    state_list.split('-')
  end
  
  def all_parents existing_parents=[]
    return [] if parents.empty?
    
    more_parents = parents + (parents - existing_parents).map do |p|
      p.all_parents(existing_parents + parents)
    end
    
    more_parents.flatten.compact
  end
  
  def all_children existing_children=[]
    return [] if children.empty?

    more_children = children + (children - existing_children).map do |c|
      c.all_children(existing_children + children)
    end
    
    more_children.flatten.compact
  end
end
