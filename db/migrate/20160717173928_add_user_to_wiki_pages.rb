class AddUserToWikiPages < ActiveRecord::Migration
  def change
    add_column :wikipages, :user_id, :integer
    add_index :wikipages, :user_id
  end
end
