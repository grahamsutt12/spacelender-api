class AddDefaultActiveToListings < ActiveRecord::Migration
  def change
    remove_column :listings, :active
    add_column :listings, :active, :boolean, default: true
  end
end
