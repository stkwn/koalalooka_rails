class RenameStudyProgressToStudyProgresses < ActiveRecord::Migration[7.1]
  def change
    rename_table :study_progress, :study_progresses
  end
end
