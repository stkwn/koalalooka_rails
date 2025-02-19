class CourseItem < ApplicationRecord
  belongs_to :course

  validates :term, presence: true

end
