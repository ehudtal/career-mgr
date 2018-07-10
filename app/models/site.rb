class Site < ApplicationRecord
  has_many :courses, dependent: :destroy
  
  has_one :location, as: :locateable
  accepts_nested_attributes_for :location

  validates :code, :name, presence: true, uniqueness: true
  
  class << self
    def cohort_for course_code
      code = course_code[0..-4]
      semester = {'S' => 'Spring', 'F' => 'Fall'}[course_code[-3]]
      year = ('20' + course_code[-2..-1]).to_i
      
      site = find_by code: code
      return nil if site.nil?
      
      course = site.courses.find_or_create_by(semester: semester, year: year)
      
      course.cohorts.first ||
        course.cohorts.create(name: "#{site.name}, #{semester} #{year}")
    end
  end
  
  def metro
    pc = PostalCode.find_by code: location.contact.postal_code
    Metro.find_by(code: pc.msa_code) || Metro.find_by(code: location.contact.state)
  end
end
