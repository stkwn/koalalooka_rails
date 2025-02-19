class RenameTypeToCourseTypeInCourses < ActiveRecord::Migration[7.1]
  def change
    rename_column :courses, :type, :course_type
  end
end
