class CreateCourseItems < ActiveRecord::Migration[7.1]
  def change
    create_table :course_items do |t|
      t.string :term, null: false
      t.json :content
      t.references :course, null: false, foreign_key: true
      t.timestamps
    end
  end
end
