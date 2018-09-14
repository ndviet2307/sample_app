class Micropost < ApplicationRecord
  belongs_to :user
  scope :created_at_desc, ->{order created_at: :desc}
  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.microposts.content.max_length}
  mount_uploader :picture, PictureUploader
  validate :picture_size

  private

  def picture_size
    return unless picture.size > Settings.microposts.upload_max_size.megabytes
    errors.add :picture,
      I18n.t(".less_than_upload_max_size",
        size: Settings.microposts.upload_max_size)
  end
end
