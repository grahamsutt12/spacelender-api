require 'test_helper'

class CardTest < ActiveSupport::TestCase

  ##
  # Card Formats based on their brands are validated by Stripe went
  # sent to the Stripe API.
  ##
  
  test "the card number should not be blank" do
    card = FactoryGirl.build(:card, :number => nil)
    assert !card.valid?, "The card number should be present."
  end

  test "the card number should be at least 13 digits long" do
    card = FactoryGirl.build(:card, :number => "4" * 12)
    assert card.number.length < 13, "The card's test number is not less than 13."
    assert !card.valid?, "The card number should be at least 13 digits long."
  end

  test "the card number should be no more than 18 digits long" do
    card = FactoryGirl.build(:card, :number => "4" * 19)
    assert card.number.length > 18, "The card's test number is not less than or equal to 18 digits."
    assert !card.valid?, "The card number should be no more than 18 digits long."
  end

  test "the EXP MONTH should not be blank" do
    card = FactoryGirl.build(:card, :exp_month => nil)
    assert !card.valid?, "The card number should be present."
  end

  test "the EXP MONTH should be no less than 2 numbers long" do
    card = FactoryGirl.build(:card, :exp_month => "1")
    assert !card.valid?, "The card number should be 2 digits long."
  end

  test "the EXP MONTH should be no more than 2 numbers long" do
    card = FactoryGirl.build(:card, :exp_month => "111")
    assert !card.valid?, "The card number should be 2 digits long."
  end

  test "the EXP YEAR should not be blank" do
    card = FactoryGirl.build(:card, :exp_year => nil)
    assert !card.valid?, "The EXP YEAR should be present."
  end

  test "the EXP YEAR should be no less than 4 numbers long" do
    card = FactoryGirl.build(:card, :exp_year => "201")
    assert !card.valid?, "The EXP YEAR should be 4 digits long."
  end

  test "the EXP YEAR should be no more than 4 numbers long" do
    card = FactoryGirl.build(:card, :exp_year => "20191")
    assert !card.valid?, "The EXP YEAR should be 4 digits long."
  end

  test "the EXP YEAR should not be less than the current year" do
    card = FactoryGirl.build(:card, :exp_year => "2015")
    assert !card.valid?, "The EXP YEAR should be 4 digits long."
  end
end
