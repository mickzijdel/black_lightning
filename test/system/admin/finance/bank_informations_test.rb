require 'application_system_test_case'


class Admin::Finance::BankInformationsTest < ApplicationSystemTestCase
  setup do
    @admin_finance_bank_information = finance_bank_informations(:with_user)
    login_as users(:admin)

    @params = {
      account_holder_name: 'System Beregard',
      account_number: '75849855',
      sort_code: '200052'
    }
  end

  test "visiting the index" do
    visit admin_finance_bank_informations_url
    assert_selector "h1", text: "Bank Information"

    assert_text "Pine Apple"
  end

  test "should create Bank information" do
    visit admin_finance_bank_informations_url
    click_on "New Bank Information"

    fill_in "Account Holder Name", with: @params[:account_holder_name]
    fill_in "Account Number", with: @params[:account_number]
    fill_in "Sort Code", with: @params[:sort_code]

    click_on "Create Bank information"

    assert_text 'The Bank Information "System Beregard" was successfully created'
  end

  test "should update Bank information" do
    visit admin_finance_bank_information_url(@admin_finance_bank_information)
    click_on "Edit", match: :prefer_exact

    fill_in "Account Holder Name", with: @params[:account_holder_name]
    fill_in "Account Number", with: @params[:account_number]
    fill_in "Sort Code", with: @params[:sort_code]

    click_on "Update Bank information"

    assert_text 'The Bank Information "System Beregard" was successfully updated.'
  end

  test "should destroy Bank information" do
    visit admin_finance_bank_information_url(@admin_finance_bank_information)

    page.accept_confirm do
      click_on 'Destroy', match: :first
    end
    assert_text 'The Bank Information "Pine Apple" has been successfully destroyed.'
  end
end
