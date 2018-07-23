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
  
  module MetroMethods
    def metro_tags
      metros.pluck(:name).join(';')
    end
  
    def metro_tags= tag_string
      self.metro_ids = Metro.where(name: tag_string.split(';')).pluck(:id)
    end
  end
end