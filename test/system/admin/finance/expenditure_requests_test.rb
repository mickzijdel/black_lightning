require 'application_system_test_case'


class Admin::Finance::ExpenditureRequestsTest < ApplicationSystemTestCase
  setup do
    @admin_finance_expenditure_request = finance_expenditure_requests(:unchecked_expenditure_request_with_bacs)
    login_as users(:admin)
  end

  test "visiting the index" do
    visit admin_finance_expenditure_requests_url
    assert_selector "h1", text: "Expenditure Requests"

    assert_text 'Receipts Printer Rolls'
  end

  test "should create Expenditure request" do
    visit admin_finance_expenditure_requests_url
    click_on "New Expenditure Request"

    fill_in "Amount", with: @admin_finance_expenditure_request.amount
    fill_in "Bank information", with: @admin_finance_expenditure_request.bank_information
    fill_in "Budget line", with: @admin_finance_expenditure_request.budget_line_id
    fill_in "Business manager notes", with: @admin_finance_expenditure_request.business_manager_notes
    fill_in "Name", with: @admin_finance_expenditure_request.name
    fill_in "Proof state", with: @admin_finance_expenditure_request.proof_status.titleize
    fill_in "Submitter notes", with: @admin_finance_expenditure_request.submitter_notes
    fill_in "Transaction state", with: @admin_finance_expenditure_request.request_status.titleize
    fill_in "User", with: @admin_finance_expenditure_request.user_id
    click_on "Create Expenditure request"

    assert_text 'The Expenditure request was successfully created'
  end

  test "should update Expenditure request" do
    visit admin_finance_expenditure_request_url(@admin_finance_expenditure_request)
    click_on "Edit", match: :prefer_exact

    fill_in "Amount", with: @admin_finance_expenditure_request.amount
    fill_in "Bank information", with: @admin_finance_expenditure_request.bank_information
    fill_in "Budget line", with: @admin_finance_expenditure_request.budget_line_id
    fill_in "Business manager notes", with: @admin_finance_expenditure_request.business_manager_notes
    fill_in "Name", with: @admin_finance_expenditure_request.name
    fill_in "Proof state", with: @admin_finance_expenditure_request.proof_status.titleize
    fill_in "Submitter notes", with: @admin_finance_expenditure_request.submitter_notes
    fill_in "Transaction state", with: @admin_finance_expenditure_request.request_status.titleize
    fill_in "User", with: @admin_finance_expenditure_request.user_id
    click_on "Update Expenditure request"

    assert_text "The Expenditure request was successfully updated."
  end

  test "should destroy Expenditure request" do
    visit admin_finance_expenditure_request_url(@admin_finance_expenditure_request)

    page.accept_confirm do
      click_on 'Destroy', match: :first
    end
    assert_text "The Expenditure Request \"Receipts Printer Rolls\" has been successfully destroyed."
    assert_not_text @admin_finance_expenditure_request.name
  end
end
