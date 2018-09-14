class Micropost < ApplicationRecord
  belongs_to :user
  scope :created_at_desc, ->{order created_at: :desc}
  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.microposts.content.max_length}
end
