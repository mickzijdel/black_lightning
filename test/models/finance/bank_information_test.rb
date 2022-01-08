require "test_helper"

class Finance::BankInformationTest < ActiveSupport::TestCase
  test 'verify fixtures pass validation' do
    # If this fails, also check the factory.
    assert finance_bank_informations(:with_user).save
    assert finance_bank_informations(:without_user).save
  end
  test 'validate sort_code and account_number' do
    bank_information = finance_bank_informations(:with_user)

    assert_raise ActiveRecord::RecordInvalid do
      bank_information.sort_code = '100000'
      bank_information.account_number = '00000001'
      bank_information.save!
    end

    assert_equal ['Account number This combination of account number and sort code is invalid. Please double-check the entered values, and check with the Business Manager if there if the issue persists.'], bank_information.errors.full_messages
  end
end
