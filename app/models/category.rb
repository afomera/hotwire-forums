class Category < ApplicationRecord
  has_many :discussions, dependent: :nullify

  scope :sorted, -> { order(name: :asc) }

  after_create_commit -> { broadcast_prepend_to "categories" }
  after_update_commit -> { broadcast_replace_to "categories" }
  after_destroy_commit -> { broadcast_remove_to "categories" }
end
