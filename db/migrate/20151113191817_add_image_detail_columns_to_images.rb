class AddImageDetailColumnsToImages < ActiveRecord::Migration
  def change
    add_column :images, :file_name, :string
    add_column :images, :url, :string
  end
end
