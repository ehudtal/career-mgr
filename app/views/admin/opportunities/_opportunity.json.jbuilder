json.extract! opportunity, :id, :name, :summary, :employer_id, :created_at, :updated_at
json.url admin_opportunity_url(opportunity, format: :json)
