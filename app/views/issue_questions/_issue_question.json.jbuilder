json.extract! issue_question, :id, :issue_id, :content, :asked_by, :priority, :created_at, :updated_at
json.url issue_question_url(issue_question, format: :json)
