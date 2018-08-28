class Metro < ApplicationRecord
  has_and_belongs_to_many :opportunities
  has_and_belongs_to_many :fellows

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
end
