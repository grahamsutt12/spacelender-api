class ChangeColumnTypesForSenderReceiverInMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :sender
    remove_column :messages, :receiver

    add_column :messages, :sender_id, :string
    add_column :messages, :receiver_id, :string

    add_index :messages, :sender_id
    add_index :messages, :receiver_id
  end
end
