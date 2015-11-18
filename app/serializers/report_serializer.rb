class ReportSerializer < ActiveModel::Serializer
  belongs_to :user, :class_name => "User"

  attributes :ref_token, :explanation
end
