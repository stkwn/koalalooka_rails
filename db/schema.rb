# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_02_24_095000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_items", force: :cascade do |t|
    t.string "term", null: false
    t.json "content"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_items_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "course_type", default: "system"
    t.bigint "learning_resource_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learning_resource_id"], name: "index_courses_on_learning_resource_id"
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "learning_plans", force: :cascade do |t|
    t.bigint "study_set_id", null: false
    t.integer "daily_goal"
    t.integer "review_interval"
    t.boolean "active", default: true
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_set_id"], name: "index_learning_plans_on_study_set_id"
  end

  create_table "learning_resources", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "publisher"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "study_progresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_item_id", null: false
    t.bigint "study_set_id", null: false
    t.integer "status", default: 0
    t.integer "confidence_level", default: 0
    t.datetime "last_studied_at"
    t.datetime "next_review_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_item_id"], name: "index_study_progresses_on_course_item_id"
    t.index ["study_set_id"], name: "index_study_progresses_on_study_set_id"
    t.index ["user_id", "course_item_id", "study_set_id"], name: "idx_study_progress_uniqueness", unique: true
    t.index ["user_id"], name: "index_study_progresses_on_user_id"
  end

  create_table "study_set_courses", force: :cascade do |t|
    t.bigint "study_set_id", null: false
    t.bigint "course_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_study_set_courses_on_course_id"
    t.index ["study_set_id", "course_id"], name: "index_study_set_courses_on_study_set_id_and_course_id", unique: true
    t.index ["study_set_id", "position"], name: "index_study_set_courses_on_study_set_id_and_position"
    t.index ["study_set_id"], name: "index_study_set_courses_on_study_set_id"
  end

  create_table "study_sets", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.integer "total_items", default: 0
    t.integer "studied_items", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_study_sets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "course_items", "courses"
  add_foreign_key "courses", "learning_resources"
  add_foreign_key "courses", "users"
  add_foreign_key "learning_plans", "study_sets"
  add_foreign_key "study_progresses", "course_items"
  add_foreign_key "study_progresses", "study_sets"
  add_foreign_key "study_progresses", "users"
  add_foreign_key "study_set_courses", "courses"
  add_foreign_key "study_set_courses", "study_sets"
  add_foreign_key "study_sets", "users"
end
