json.extract! opportunity, :id, :name, :description, :employer_id, :created_at, :updated_at
json.url opportunity_url(opportunity, format: :json)
