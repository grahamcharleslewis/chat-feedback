class RenameFeedbackTypeToLevel < ActiveRecord::Migration[7.0]
  def change
    rename_column :feedbacks, :type, :level
  end
end
