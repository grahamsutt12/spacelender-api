class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.belongs_to :listing, index: true, foreign_key: true
      t.datetime :start
      t.datetime :end
      t.string :token, index: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
