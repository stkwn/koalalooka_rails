class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.text :description
      t.string :type, default: 'system'
      t.references :learning_resource, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end