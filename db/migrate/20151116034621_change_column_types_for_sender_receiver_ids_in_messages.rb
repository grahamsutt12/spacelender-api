class ChangeColumnTypesForSenderReceiverIdsInMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :sender_id
    remove_column :messages, :recipient_id

    add_column :messages, :sender, :string
    add_column :messages, :receiver, :string

    add_index :messages, :sender
    add_index :messages, :receiver
  end
end
