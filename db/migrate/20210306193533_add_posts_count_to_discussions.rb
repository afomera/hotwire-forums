class AddPostsCountToDiscussions < ActiveRecord::Migration[6.1]
  def change
    add_column :discussions, :posts_count, :integer, default: 0
  end
end
