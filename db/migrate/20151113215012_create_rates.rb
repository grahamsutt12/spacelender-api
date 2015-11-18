class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.references :rateable, polymorphic: true, index: true
      t.float :amount
      t.integer :type

      t.timestamps null: false
    end
  end
end
