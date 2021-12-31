require "application_system_test_case"


class Admin::Finance::TransactionCategoriesTest < ApplicationSystemTestCase
  setup do
    @admin_finance_transaction_category = finance_transaction_categories(:tech)
    login_as users(:admin)
  end

  test "visiting the index" do
    visit admin_admin_finance_transaction_categories_url
    assert_selector "h1", text: "Transaction categories"

    assert_text "REPLACE THIS WITH THE NAME OF A FIXTURE ITEM"
  end

  test "should create Transaction category" do
    visit admin_admin_finance_transaction_categories_url
    click_on "New Transaction category"

    check "Active" if @admin_finance_transaction_category.active
    fill_in "Description", with: @admin_finance_transaction_category.description
    fill_in "Hint", with: @admin_finance_transaction_category.hint
    fill_in "Name", with: @admin_finance_transaction_category.name
    fill_in "Nominal code", with: @admin_finance_transaction_category.nominal_code
    fill_in "Transaction type", with: @admin_finance_transaction_category.transaction_type
    click_on "Create Transaction category"

    assert_text 'The Transaction category was successfully created'
  end

  test "should update Transaction category" do
    visit admin_admin_finance_transaction_categories_url(@admin_finance_transaction_category)
    click_on "Edit this transaction category", match: :prefer_exact

    check "Active" if @admin_finance_transaction_category.active
    fill_in "Description", with: @admin_finance_transaction_category.description
    fill_in "Hint", with: @admin_finance_transaction_category.hint
    fill_in "Name", with: @admin_finance_transaction_category.name
    fill_in "Nominal code", with: @admin_finance_transaction_category.nominal_code
    fill_in "Transaction type", with: @admin_finance_transaction_category.transaction_type
    click_on "Update Transaction category"

    assert_text "The Transaction category was successfully updated."
  end

  test "should destroy Transaction category" do
    visit admin_admin_finance_transaction_categories_url(@admin_finance_transaction_category)
    click_on "Destroy this transaction category", match: :first

    assert_text "The Transaction category has been successfully destroyed."
  end
end
