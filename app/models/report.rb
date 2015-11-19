class Report < ActiveRecord::Base
  belongs_to :user

  def self.example
    JSON.pretty_generate({"report":{"ref_token": "XasJjf2ojEbpU7tN_WGX7Q","explanation": "It was just about time."}})
  end
end
