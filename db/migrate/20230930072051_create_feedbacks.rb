class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.integer :chat_id
      t.string :uuid
      t.string :version
      t.string :type
      t.json :response

      t.timestamps
    end
  end
end
