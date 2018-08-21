module Taggable
  def self.included base
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def taggable *taggables
      if taggables.include?(:industries)
        has_and_belongs_to_many :industries, dependent: :destroy
        include IndustryMethods
      end
      
      if taggables.include?(:interests)
        has_and_belongs_to_many :interests, dependent: :destroy
        include InterestMethods
      end
      
      if taggables.include?(:majors)
        has_and_belongs_to_many :majors, dependent: :destroy
        include MajorMethods
      end
      
      if taggables.include?(:industry_interests)
        include IndustryInterestMethods
      end
      
      if taggables.include?(:metros)
        has_and_belongs_to_many :metros, dependent: :destroy
        include MetroMethods
      end
    end
  end
  
  module IndustryMethods
    def industry_tags
      industries.pluck(:name).join(';')
    end
  
    def industry_tags= tag_string
      self.industry_ids = Industry.where(name: tag_string.split(';')).pluck(:id)
    end
  end
  
  module InterestMethods
    def interest_tags
      interests.pluck(:name).join(';')
    end
  
    def interest_tags= tag_string
      self.interest_ids = Interest.where(name: tag_string.split(';')).pluck(:id)
    end
  end
  
  module MajorMethods
    def major_tags
      majors.pluck(:name).join(';')
    end
  
    def major_tags= tag_string
      self.major_ids = Major.where(name: tag_string.split(';')).pluck(:id)
    end
  end
  
  module IndustryInterestMethods
    def industry_interest_tags
      (industries.pluck(:name) | interests.pluck(:name) | majors.pluck(:name)).sort.join(';')
    end
  
    def industry_interest_tags= tag_string
      self.industry_tags = tag_string
      self.interest_tags = tag_string
      self.major_tags = tag_string
    end
  end
  
  module MetroMethods
    def metro_tags
      metros.pluck(:name).join(';')
    end
  
    def metro_tags= tag_string
      self.metro_ids = Metro.where(name: tag_string.split(';')).pluck(:id)
    end
    
    def add_metro metro
      if (metro && !self.metros.include?(metro))
        self.metros << metro
      end
    end
  end
end