class User < ApplicationRecord
  has_secure_password

  has_many :study_sets, dependent: :destroy
  has_many :study_progress_records, class_name: 'StudyProgress', dependent: :destroy
  has_many :courses
  has_many :study_set_courses, through: :study_sets
  has_many :learning_plans, through: :study_sets

  validates :name, presence: true
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    format: { with: /\S+@\S+\.\S+/ }
  validates :password, length: { minimum: 6 }

  def active_study_sets
    study_sets.joins(:learning_plan).where(learning_plans: { active: true })
  end

  def daily_study_items
    active_study_sets.map(&:next_items_to_study).flatten.uniq
  end
end
