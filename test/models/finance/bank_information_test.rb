require "test_helper"

class Finance::BankInformationTest < ActiveSupport::TestCase
  test 'validate sort_code and account_number' do
    bank_information = finance_bank_informations(:with_user)
  
    bank_information.save!

    assert_raise ActiveRecord::RecordInvalid do
      bank_information.sort_code = 000000
      bank_information.save!
    end
  end 
end
