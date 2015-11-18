class AddConfirmationColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirm_token, :string
    add_column :users, :active, :boolean, default: false
  end
end
