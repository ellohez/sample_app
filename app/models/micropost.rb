class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  # The default_scope method allows us to arrange for a default ordering on the results of a database query
  # In this case, we arrange for microposts to be retrieved in descending order of creation
  # This uses the 'stabby lamda' syntax -> { ... } to create an anonymous function
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # Essential server-side validations in case a user tries to bypass the browser image restrictions we have made
  # by issuing a direct POST request using e.g. curl
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: 'must be a valid image format' },
            size: { less_than: 5.megabytes,
                    message: 'should be less than 5MB' }
end
