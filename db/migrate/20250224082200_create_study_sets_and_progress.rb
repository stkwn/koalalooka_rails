class CreateStudySetsAndProgress < ActiveRecord::Migration[7.1]
  def change
    create_table :study_sets do |t|
      t.string :title, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.integer :total_items, default: 0
      t.integer :studied_items, default: 0

      t.timestamps
    end

    create_table :study_set_courses do |t|
      t.references :study_set, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end

    create_table :learning_plans do |t|
      t.references :study_set, null: false, foreign_key: true
      t.integer :daily_goal # Number of items to study per day
      t.integer :review_interval # Days between reviews
      t.boolean :active, default: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    create_table :study_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course_item, null: false, foreign_key: true
      t.references :study_set, null: false, foreign_key: true
      t.integer :status, default: 0 # 0: not started, 1: in progress, 2: completed
      t.integer :confidence_level, default: 0 # 0-5 scale
      t.datetime :last_studied_at
      t.datetime :next_review_at

      t.timestamps
    end

    add_index :study_set_courses, [:study_set_id, :course_id], unique: true
    add_index :study_set_courses, [:study_set_id, :position]
    add_index :study_progresses, [:user_id, :course_item_id, :study_set_id], unique: true, name: 'idx_study_progress_uniqueness'
  end
end
