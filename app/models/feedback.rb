class Feedback < ApplicationRecord
  belongs_to :chat, optional: true
end
