class LearningPlan < ApplicationRecord
  belongs_to :study_set

  validates :daily_goal, presence: true, numericality: { greater_than: 0 }
  validates :review_interval, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return unless start_date && end_date
    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
