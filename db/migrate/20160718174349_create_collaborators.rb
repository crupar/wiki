class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :wikipage, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
