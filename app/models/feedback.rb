class Feedback < ApplicationRecord
  belongs_to :chat, optional: true

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

private

  def self.load_questions(type)
    puts "Loading [#{type}] questions..."
    config = YAML.load_file("data/#{type}.yaml")
    config[ENV["#{type.upcase}_FEEDBACK_VERSION"]]
  end
end


