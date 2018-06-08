json.extract! task, :id, :name, :due_at, :completed, :notes, :taskable_id, :taskable_type, :created_at, :updated_at
json.url task_url(task, format: :json)
