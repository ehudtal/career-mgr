json.extract! contact, :id, :address_1, :address_2, :city, :state, :postal_code, :phone, :email, :url, :contactable_id, :contactable_type, :created_at, :updated_at
json.url admin_contact_url(contact, format: :json)
