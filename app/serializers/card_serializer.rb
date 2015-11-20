class CardSerializer < ActiveModel::Serializer
  attributes :brand, :card_token, :last4
end
