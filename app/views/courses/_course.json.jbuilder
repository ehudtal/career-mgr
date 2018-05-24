json.extract! course, :id, :semester, :year, :site_id, :created_at, :updated_at
json.url course_url(course, format: :json)
