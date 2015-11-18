class AddReasonColumnToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :reason, :text
  end
end
