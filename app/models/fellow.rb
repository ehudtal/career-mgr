require 'digest/md5'
require 'csv'

class Fellow < ApplicationRecord
  has_one :contact, as: :contactable
  accepts_nested_attributes_for :contact
  
  has_many :cohort_fellows, dependent: :destroy
  has_many :cohorts, through: :cohort_fellows
  
  has_and_belongs_to_many :interests, dependent: :destroy
  has_and_belongs_to_many :industries, dependent: :destroy
  has_and_belongs_to_many :metros, dependent: :destroy
  
  belongs_to :employment_status
  
  validates :first_name, :last_name, :employment_status_id, presence: true
  
  validates :graduation_semester, inclusion: {in: (Course::VALID_SEMESTERS + [nil])}
  validates :graduation_year, numericality: {greater_than: 2010, less_than: 2050, allow_nil: true, only_integer: true}
  validates :graduation_fiscal_year, numericality: {greater_than: 2010, less_than: 2050, allow_nil: true, only_integer: true}
  
  validates :gpa, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 4.0, allow_nil: true}
  validates :efficacy_score, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0, allow_nil: true}
  
  before_create :generate_key
  
  class << self
    def import contents
      CSV.new(contents, headers: true, skip_lines: /(Anticipated Graduation|STUDENT INFORMATION)/).each do |data|
        cohort = Site.cohort_for data['Braven class']

        next if cohort.nil?
        
        attributes = {
          first_name: data['First Name'],
          last_name: data['Last Name'],
          phone: data['Phone'],
          email: data['Email'],
          graduation_year: data['Ant. Grad Year'],
          graduation_semester: data['Ant. Grad Semester'],
          graduation_fiscal_year: 2000 + data['Grad FY'][2..4].to_i,
          interests_description: ensure_string(data['Post-Graduate Career Interests']),
          major: ensure_string(data['Major']),
          affiliations: ensure_string(data['Org Affiliations']),
          gpa: ensure_float(data['GPA']),
          linkedin_url: data['LinkedIn Profile URL'],
          staff_notes: ensure_string(data['Braven Staff Notes']),
          grade: percent_to_decimal(data['Grade']),
          attendance: percent_to_decimal(data['Attendance']),
          nps_response: ensure_int(data['NPS Response']),
          feedback: ensure_string(data['LC feedback']),
          endorsement: strength_for(data['LC Endorsement']),
          professionalism: readiness_for(data['LC professionalism rating']),
          teamwork: readiness_for(data['LC teamwork rating'])
        }

        next unless Course::VALID_SEMESTERS.include?(attributes[:graduation_semester])
        
        cohort.fellows.create_or_update(attributes)
      end
    end
    
    def strength_for string
      ['Not at all Strongly', 'Somewhat Strongly', 'Strongly', 'Very Strongly', 'Extremely Strongly'].index(string)
    end
    
    def readiness_for string
      ['Not at all Ready', 'Slightly Ready', 'Moderately Ready', 'Mostly Ready', 'Completely Ready'].index(string)
    end
    
    def percent_to_decimal string
      (string || '0').gsub(/[^0-9]+/,'').to_f / 100
    end
    
    def ensure_string string
      (string || '').strip
    end
    
    def ensure_int string
      (string || 0).to_i
    end
    
    def ensure_float string
      (string || 0.0).to_f
    end
  end
  
  def cohort
    cohorts.order('id desc').first
  end
  
  def full_name
    [first_name, last_name].join(' ').strip
  end
  
  def graduation
    [graduation_semester, graduation_year].join(' ').strip
  end
  
  def nearest_distance zip_list
    zip_list.map{|zip| distance_from(zip)}.min
  end
  
  def distance_from postal_code
    return @distance_from[postal_code] if defined?(@distance_from) && @distance_from.has_key?(postal_code)
    return nil unless contact && contact.postal_code
    
    @distance_from ||= {}
    @distance_from[postal_code] = PostalCode.distance(contact.postal_code, postal_code)
  end
  
  def industry_tags
    industries.pluck(:name).join(';')
  end
  
  def industry_tags= tag_string
    self.industry_ids = Industry.where(name: tag_string.split(';')).pluck(:id)
  end
  
  def interest_tags
    interests.pluck(:name).join(';')
  end
  
  def interest_tags= tag_string
    self.interest_ids = Interest.where(name: tag_string.split(';')).pluck(:id)
  end
  
  def metro_tags
    metros.pluck(:name).join(';')
  end
  
  def metro_tags= tag_string
    self.metro_ids = Metro.where(name: tag_string.split(';')).pluck(:id)
  end
  
  private
  
  def generate_key
    return unless key.nil?
    unique_count = self.class.where(first_name: first_name, last_name: last_name, graduation_year: graduation_year).count
    
    hash = Digest::MD5.hexdigest([first_name, last_name, graduation_year, unique_count].join('-'))[0,4]
    self.key = [first_name[0].upcase, last_name[0].upcase, ((graduation_year || 0) % 100), hash].join('').upcase
  end
end
