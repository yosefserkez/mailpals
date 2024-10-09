class Question < ApplicationRecord
    validates :prompt, presence: true
    validates :category, presence: true
end
