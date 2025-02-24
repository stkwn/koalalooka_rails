class StudyProgress < ApplicationRecord
  belongs_to :user
  belongs_to :course_item
  belongs_to :study_set

  validates :user_id, uniqueness: { scope: [:course_item_id, :study_set_id] }
  
  enum status: {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }

  before_save :calculate_next_review, if: :review_needed?

  def mark_as_studied!(confidence)
    self.confidence_level = confidence
    self.status = confidence >= 4 ? :completed : :in_progress
    self.last_studied_at = Time.current
    save!
    study_set.update_progress_counts
  end

  private

  def review_needed?
    status_changed? || confidence_level_changed? || last_studied_at_changed?
  end

  def calculate_next_review
    return unless last_studied_at

    # If no learning plan, set short intervals for testing
    base_interval = study_set&.learning_plan&.review_interval || 1

    multiplier = case confidence_level.to_i
    when 0..1 then 0.25 # Review in 6 hours
    when 2..3 then 0.5  # Review in 12 hours
    when 4..5 then 1.0  # Review in 24 hours
    else 0.25           # Default to 6 hours if no confidence level
    end

    # If it's been completed before, double the interval
    multiplier *= 2 if status == 'completed'

    self.next_review_at = last_studied_at + (base_interval * multiplier).days
  end
end
