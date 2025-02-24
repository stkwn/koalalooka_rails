class StudySet < ApplicationRecord
  belongs_to :user
  has_one :learning_plan, dependent: :destroy
  has_many :study_set_courses, dependent: :destroy
  has_many :courses, through: :study_set_courses
  has_many :study_progress_records, class_name: 'StudyProgress', dependent: :destroy

  validates :title, presence: true

  def update_progress_counts
    self.total_items = courses.joins(:course_items).count
    self.studied_items = study_progress_records.where(status: 2).count
    save
  end

  def progress_percentage
    total_items.zero? ? 0 : (studied_items.to_f / total_items * 100).round(2)
  end

  def next_items_to_study(limit = nil)
    limit ||= learning_plan&.daily_goal || 10
    
    # Get items that need review first
    review_items = study_progress_records
      .joins(course_item: :course)
      .where(courses: { id: course_ids })
      .where("next_review_at <= ?", Time.current)
      .order(next_review_at: :asc)
      .limit(limit)
      .map(&:course_item)

    remaining = limit - review_items.size

    if remaining > 0
      # Then get new items that haven't been studied
      new_items = CourseItem
        .joins(:course)
        .joins("LEFT JOIN study_progresses ON study_progresses.course_item_id = course_items.id AND study_progresses.study_set_id = #{ActiveRecord::Base.sanitize_sql_array(['?', id])}")
        .where(courses: { id: course_ids })
        .where("study_progresses.id IS NULL")
        .limit(remaining)

      review_items + new_items
    else
      review_items
    end
  end
end
