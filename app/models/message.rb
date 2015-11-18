class Message < ActiveRecord::Base
  belongs_to :receiver, :class_name => "User", :inverse_of => :received_messages
  belongs_to :sender, :class_name => "User", :inverse_of => :sent_messages

  enum :status => [:unread, :read, :archived]
end
