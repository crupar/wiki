class CreateWikiPages < ActiveRecord::Migration
  def change
    create_table :wikipages do |t|
      t.string :title
      t.text :body
      t.boolean :public, default: false
      t.string :slug, unique: true
      t.timestamps null: false
    end
  end
end
