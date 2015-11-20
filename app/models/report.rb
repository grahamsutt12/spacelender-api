class Report < ActiveRecord::Base
  belongs_to :user

  def self.example_request
    JSON.pretty_generate({"report":{"ref_token": "XasJjf2ojEbpU7tN_WGX7Q","explanation": "It was just about time."}})
  end

  def self.example_response
    JSON.pretty_generate({"ref_token": "XasJjf2ojEbpU7tN_WGX7Q","explanation": "It was just about time.","user":{"email": "grahamsutton1@gmail.com","role": "employee","first_name": "Graham","last_name": "Sutton","slug": "graham-283384","active": true}})
  end
end
