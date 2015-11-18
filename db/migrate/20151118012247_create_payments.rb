class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :reservation, index: true, foreign_key: true
      t.string :payer_id
      t.string :payee_id
      t.float :amount
      t.float :fee
      t.string :card
      t.integer :status, default: 0
      t.string :token

      t.timestamps null: false
    end
  end
end
