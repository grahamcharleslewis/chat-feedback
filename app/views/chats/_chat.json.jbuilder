json.extract! chat, :id, :uuid, :prompt, :reply, :created_at, :updated_at
json.url chat_url(chat, format: :json)
