class AddMerchantColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :merchant_account, :string
    add_column :users, :access_code, :string
    add_column :users, :publishable_key, :string
  end
end
