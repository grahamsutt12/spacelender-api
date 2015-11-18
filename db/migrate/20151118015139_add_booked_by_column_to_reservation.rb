class AddBookedByColumnToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :booked_by, :string

    add_index :reservations, :booked_by
  end
end
