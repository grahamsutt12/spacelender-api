class Message < ActiveRecord::Base
  belongs_to :receiver, :class_name => "User", :inverse_of => :received_messages
  belongs_to :sender, :class_name => "User", :inverse_of => :sent_messages

  enum :status => [:unread, :read, :archived]

  def self.example_request
    JSON.pretty_generate({"message": {"sender_id": "graham-283384","receiver_id": "steg-389025","body": "Hi bro! What\'s up?"}})
  end

  def self.example_response(action)
    if action == "index"
      JSON.pretty_generate([{"sender_id": "graham-283384","receiver_id": "steg-389025","status": "unread","body": "Hi bro! What's up?","created_at": "2015-11-16T07:14:09.582Z"},{"sender_id": "steg-389025","receiver_id": "graham-283384","status": "unread","body": "Not much, dude.","created_at": "2015-11-19T19:01:05.385Z"}])
    end
  end
end
