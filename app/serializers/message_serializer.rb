class MessageSerializer < ActiveModel::Serializer
  attributes :sender_id, :receiver_id, :status, :body, :created_at
end
