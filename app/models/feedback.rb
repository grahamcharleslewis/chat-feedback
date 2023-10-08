class Feedback < ApplicationRecord
  belongs_to :chat, optional: true

  scope :for_csv_export, -> { 
    select(self.headers, :response).where(
      version: [ENV["CONVERSATION_FEEDBACK_VERSION"], ENV["MESSAGE_FEEDBACK_VERSION"]]
    )
  }

  def created_at_formatted
    created_at.strftime("%d/%m/%Y %H:%M:%S")
  end

  def self.headers
    [:uuid, :version, :level, :created_at]
  end

  def self.message_questions
    @@message_questions ||= load_questions("message")
  end

  def message_questions
    self.class.message_questions
  end

  def self.conversation_questions
    @@conversation_questions ||= load_questions("conversation")
  end

  def conversation_questions
    self.class.conversation_questions
  end

  def self.message_titles
    self.message_questions["questions"].pluck("title")
  end

  def self.conversation_titles
    self.conversation_questions["questions"].pluck("title")
  end

  def message_answers
    answers(message_questions["questions"])
  end

  def conversation_answers
    answers(conversation_questions["questions"])
  end

private

  def self.load_questions(level)
    config = YAML.load_file("data/#{level}.yaml")
    config[ENV["#{level.upcase}_FEEDBACK_VERSION"]]
  end

  def answers(questions)
    question_answers = []
    questions.each do |question|
      if response[question["id"]].is_a?(Hash)
        question_answers << response[question["id"]].values.join(" | ")
      else
        question_answers << response[question["id"]]
      end
    end
    question_answers
  end
end
