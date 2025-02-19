class LearningResource < ApplicationRecord

  has_many :courses, dependent: :destroy

  validates :title, presence: true

end
