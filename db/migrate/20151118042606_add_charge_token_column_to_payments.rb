class AddChargeTokenColumnToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :charge, :string
  end
end
