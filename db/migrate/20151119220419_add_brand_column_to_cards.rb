class AddBrandColumnToCards < ActiveRecord::Migration
  def change
    add_column :cards, :brand, :string
  end
end
