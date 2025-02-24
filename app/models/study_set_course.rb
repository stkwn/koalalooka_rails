class StudySetCourse < ApplicationRecord
  belongs_to :study_set
  belongs_to :course

  validates :course_id, uniqueness: { scope: :study_set_id }
  acts_as_list scope: :study_set

  after_create :create_progress_records
  after_destroy :cleanup_progress_records

  private

  def create_progress_records
    course.course_items.each do |item|
      StudyProgress.find_or_create_by!(
        user: study_set.user,
        course_item: item,
        study_set: study_set
      )
    end
    study_set.update_progress_counts
  end

  def cleanup_progress_records
    StudyProgress.where(
      study_set: study_set,
      course_item_id: course.course_items.pluck(:id)
    ).destroy_all
    study_set.update_progress_counts
  end
end
