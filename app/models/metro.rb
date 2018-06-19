class Metro < ApplicationRecord
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: true

  class << self
    def load_txt filename
      delete_all
    
      attributes = []
      
      File.open(filename, 'r') do |f|
        while line = f.gets
          fields = line.chomp.split("\t")
          
          code = fields[0].strip
          name = fields[1].strip.gsub(/,\s*/, ', ')
          
          attributes << {code: code, name: name}
        end
        
        create attributes
      end
    end
  end
end
