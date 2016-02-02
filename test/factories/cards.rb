FactoryGirl.define do
  factory :card, :class => "Card" do
    number "4242424242424242"
    exp_month "10"
    exp_year "2020"
    cvc "123"
    name "Graham Sutton"
    address_line1 "123 Deer Street"
    address_city "Wichita"
    address_state "KS"
    address_country "United States"
    address_zip "33333"
  end
end