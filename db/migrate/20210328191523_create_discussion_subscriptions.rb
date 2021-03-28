class CreateDiscussionSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :discussion_subscriptions do |t|
      t.references :discussion, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :subscription_type

      t.timestamps
    end
  end
end
