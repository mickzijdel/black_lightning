require "application_system_test_case"

class Admin::Finance::NominalCodesTest < ApplicationSystemTestCase
  setup do
    @finance_nominal_code = finance_nominal_codes(:sundry)
    login_as users(:admin)
  end

  test "visiting the index" do
    visit admin_finance_nominal_codes_url
    assert_selector "h1", text: "Nominal Codes"

    # Assert the item in the table appears.
    assert_text "439999 - Sundry Expenditure"
  end

  test "creating a Nominal code" do
    visit admin_finance_nominal_codes_url
    click_on "New Nominal Code"

    check "Active" if @finance_nominal_code.active
    fill_in "Code", with: 321451
    fill_in "Description", with: @finance_nominal_code.description
    fill_in "Name", with: 'Create Test'
    click_on "Create Nominal code"

    assert_text 'The Nominal Code \'321451 - Create Test\' was successfully created'
  end

  test "updating a Nominal code" do
    visit admin_finance_nominal_codes_url
    click_on "Edit", match: :prefer_exact

    un_check "Active" unless @finance_nominal_code.active
    fill_in "Code", with: @finance_nominal_code.code
    fill_in "Description", with: @finance_nominal_code.description
    fill_in "Name", with: @finance_nominal_code.name
    click_on "Update Nominal code"

    assert_text "The Nominal Code '439999 - Sundry Expenditure' was successfully updated."
  end

  test "destroying a Nominal code" do
    visit admin_finance_nominal_code_url(finance_nominal_codes(:sundry))
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text "The Nominal Code \"439999 - Sundry Expenditure\" has been successfully destroyed."

    visit admin_finance_nominal_codes_url

    refute_text '439999 - Sundry Expenditure'
  end
end
