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

    if params["level"] == "conversation"
      questions = conversation_questions["questions"]
    else
      questions = message_questions["questions"]
    end

    questions.each do |question|
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

  def self.csv_headers
    column_names + message_questions["questions"].pluck("title") + conversation_questions["questions"].pluck("title")
  end

  def self.csv_line(feedback)
    if feedback.level == "conversation"
      length = message_questions["questions"].length
      feedback.attributes.values + Array.new(length) { "" } + JSON.parse(feedback.response).values
    else
      length = conversation_questions["questions"].length
      feedback.attributes.values + JSON.parse(feedback.response).values + Array.new(length) { "" }
    end
  end

private

  def self.load_questions(level)
    puts "Loading [#{level}] questions..."
    config = YAML.load_file("data/#{level}.yaml")
    config[ENV["#{level.upcase}_FEEDBACK_VERSION"]]
  end
end
