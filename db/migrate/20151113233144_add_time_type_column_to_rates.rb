class AddTimeTypeColumnToRates < ActiveRecord::Migration
  def change
    remove_column :rates, :type
    add_column :rates, :time_type, :integer
  end
end
