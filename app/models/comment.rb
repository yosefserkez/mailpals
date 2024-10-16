class Comment < ApplicationRecord
  belongs_to :member
  belongs_to :answer

  validates :content, presence: true
end
