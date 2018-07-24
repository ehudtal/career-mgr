json.extract! site, :id, :name, :created_at, :updated_at
json.url admin_site_url(site, format: :json)
