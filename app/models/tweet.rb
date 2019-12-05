class Tweet < ApplicationRecord
  # Associations
  belongs_to :user, presence: true

  # Validations
  validates :content, presence: true, length: { maximum: 140 }
end
