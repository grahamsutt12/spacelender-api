class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :password_salt
      t.integer :role, default: 0
      t.string :auth_token
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
