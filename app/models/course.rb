class Course < ApplicationRecord

  enum course_type: { system: "system", user: "user" }

  belongs_to :learning_resource
  belongs_to :user, optional: true
  has_many :course_items, dependent: :destroy
  
  validates :title, presence: true
end
