class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :amount
      t.string :stripe_charge_id

      t.timestamps null: false
    end
  end
end
