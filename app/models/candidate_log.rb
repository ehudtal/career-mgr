class CandidateLog < ApplicationRecord
  belongs_to :candidate, class_name: 'FellowOpportunity'
end
