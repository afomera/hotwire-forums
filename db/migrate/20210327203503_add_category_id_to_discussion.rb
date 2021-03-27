class AddCategoryIdToDiscussion < ActiveRecord::Migration[6.1]
  def change
    add_column :discussions, :category_id, :bigint
  end
end
