class Metro < ApplicationRecord
  has_and_belongs_to_many :opportunities
  has_and_belongs_to_many :fellows

  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: true

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
        
        attributes << {code: code, name: name}
      end
        
      create attributes
    end
  end
end
