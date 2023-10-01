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

  def self.create_response(params)
    response = {}
    checkboxes = []

    message_questions["questions"].each do |question|
      response[question["title"]] = ""
      if question["datatype"] == "checkbox"
        response[question["title"]] = []
        checkboxes << question["title"]
      end
    end

    params.each do |key, value|
      if key.starts_with?("answer_")
        question = key.split("_")[1]
        if checkboxes.include?(question)
          response[question] << value
        else
          response[question] = value
        end
      end 
    end 

    response.to_json
  end

private

  def self.load_questions(level)
    puts "Loading [#{level}] questions..."
    config = YAML.load_file("data/#{level}.yaml")
    config[ENV["#{level.upcase}_FEEDBACK_VERSION"]]
  end
end


