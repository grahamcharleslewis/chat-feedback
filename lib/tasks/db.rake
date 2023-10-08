require "csv"

# Export to file
# CSV.open("filename.csv", "w") do |csv|
# end

namespace :db do
  desc "Exports data from Chats as CSV"
  task export_chat: :environment do
    chat_csv_string = CSV.generate do |csv|
      csv << Chat.headers
      Chat.for_csv_export.each do |chat|
        csv << [chat.uuid, chat.prompt, chat.reply, chat.created_at_formatted]
      end
    end
    puts chat_csv_string
  end 

  desc "Exports data from Feedback as CSV"
  task export_feedback: :environment do
    feedback_csv_string = CSV.generate do |csv|
      csv << Feedback.headers + Feedback.message_titles + Feedback.conversation_titles
      Feedback.for_csv_export.each do |feedback|
        question_answers = feedback.message_answers
        question_answers += feedback.conversation_answers
        csv << [feedback.uuid, feedback.version, feedback.level, feedback.created_at_formatted] + question_answers
      end
    end
    puts feedback_csv_string
  end 

  desc "Exports data from Chats and Feedback as CSV"
  task export: :environment do
    Rake::Task["db:export_chat"].execute
    Rake::Task["db:export_feedback"].execute
  end
end
