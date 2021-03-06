class Post < ApplicationRecord
  belongs_to :discussion, counter_cache: true, touch: true
  belongs_to :user, default: -> { Current.user }

  has_rich_text :body

  validates :body, presence: true

  after_create_commit -> { broadcast_append_to discussion, partial: "discussions/posts/post", locals: { post: self }}
end
