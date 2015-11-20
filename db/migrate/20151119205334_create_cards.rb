class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :card_token
      t.string :last4

      t.timestamps null: false
    end
  end
end
