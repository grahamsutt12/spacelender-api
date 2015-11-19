class Message < ActiveRecord::Base
  belongs_to :receiver, :class_name => "User", :inverse_of => :received_messages
  belongs_to :sender, :class_name => "User", :inverse_of => :sent_messages

  enum :status => [:unread, :read, :archived]

  def self.example
    JSON.pretty_generate({"message": {"sender_id": "graham-283384","receiver_id": "steg-389025","body": "Hi bro! What\'s up?"}})
  end
end
