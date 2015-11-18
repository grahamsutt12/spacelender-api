class RemoveReadColumnFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :read
    add_column :messages, :status, :integer, default: 0
  end
end
