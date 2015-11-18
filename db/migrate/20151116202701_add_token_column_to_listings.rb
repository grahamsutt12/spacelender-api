class AddTokenColumnToListings < ActiveRecord::Migration
  def change
    add_column :listings, :token, :string
  end
end
