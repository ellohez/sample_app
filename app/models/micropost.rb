class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  # The default_scope method allows us to arrange for a default ordering on the results of a database query
  # In this case, we arrange for microposts to be retrieved in descending order of creation
  # This uses the 'stabby lamda' syntax -> { ... } to create an anonymous function
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
