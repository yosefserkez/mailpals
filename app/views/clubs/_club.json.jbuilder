json.extract! club, :id, :title, :description, :active, :default_number_questions, :delivery_time, :delivery_frequency, :invite_code, :sections, :created_at, :updated_at
json.url club_url(club, format: :json)
