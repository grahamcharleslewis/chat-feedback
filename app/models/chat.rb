class Chat < ApplicationRecord
  has_many :feedbacks

  scope :for_csv_export, -> { 
    select(self.headers).where(uuid: Feedback.for_csv_export.map(&:uuid))
  }

  def created_at_formatted
    created_at.strftime("%d/%m/%Y %H:%M:%S")
  end

  def self.headers
    [:uuid, :prompt, :reply, :created_at]
  end
end
