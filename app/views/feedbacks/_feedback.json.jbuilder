json.extract! feedback, :id, :chat_id, :uuid, :version, :type, :response, :created_at, :updated_at
json.url feedback_url(feedback, format: :json)
