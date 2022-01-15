require "application_system_test_case"


class Admin::Finance::TransactionCategoriesTest < ApplicationSystemTestCase
  setup do
    @admin_finance_transaction_category = finance_transaction_categories(:tech)
    login_as users(:admin)
  end

  test "visiting the index" do
    visit admin_finance_transaction_categories_url
    assert_selector "h1", text: "Transaction Categories"

    assert_text 'For equipment hires, gels, etc'
  end

  test "should create Transaction category" do
    visit admin_finance_transaction_categories_url
    click_on "New Transaction Category"

    check "Active" if @admin_finance_transaction_category.active
    fill_in "Description", with: @admin_finance_transaction_category.description
    fill_in "Hint", with: @admin_finance_transaction_category.hint
    fill_in "Name", with: 'Sustainability'
    select @admin_finance_transaction_category.nominal_code.to_label, from: 'Nominal Code'
    select @admin_finance_transaction_category.transaction_type.titleize, from: 'Transaction Type'

    click_on "Create Transaction category"

    assert_text 'The Transaction Category "Sustainability" was successfully created'
  end

  test "should update Transaction category" do
    visit admin_finance_transaction_category_url(@admin_finance_transaction_category)
    click_on 'Edit', match: :prefer_exact

    check "Active" if @admin_finance_transaction_category.active
    fill_in "Description", with: @admin_finance_transaction_category.description
    fill_in "Hint", with: @admin_finance_transaction_category.hint
    fill_in "Name", with: @admin_finance_transaction_category.name
    select @admin_finance_transaction_category.nominal_code.to_label, from: 'Nominal Code'
    select @admin_finance_transaction_category.transaction_type.titleize, from: 'Transaction Type'
    click_on "Update Transaction category"

    assert_text 'The Transaction Category "Tech" was successfully updated.'
  end

  test "should destroy Transaction category" do
    visit admin_finance_transaction_category_url(@admin_finance_transaction_category)

    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text "The Transaction Category \"Tech\" has been successfully destroyed."
  end
end
