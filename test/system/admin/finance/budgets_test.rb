require "application_system_test_case"

class Admin::Finance::BudgetsTest < ApplicationSystemTestCase
  setup do
    @admin_finance_budget = finance_budgets(:front_of_house)
    login_as users(:admin)
  end

  test "visiting the index" do
    visit admin_finance_budgets_url
    assert_selector "h1", text: "Budgets"

    assert_text 'Front of House'
  end

  test "should create Budget" do
    visit admin_finance_budgets_url
    click_on "New Budget"

    select @admin_finance_budget.status.titleize, from: 'Status'
    select @admin_finance_budget.budget_category.titleize, from: 'Budget Category'
    select @admin_finance_budget.event&.title, from: 'Event'
    fill_in "Title", with: 'IT'
    fill_in 'Notes', with: 'Yada Yada'

    click_on 'Budget Lines'
    fill_in 'finance_budget[budget_lines_attributes][0][name]', with: 'Test Budgetline'
    fill_in 'finance_budget[budget_lines_attributes][0][allocated]', with: -100
    click_on "Create Budget"

    assert_text 'The Budget "IT" was successfully created'
  end

  test "should update Budget" do
    visit admin_finance_budget_url(@admin_finance_budget)
    click_on 'Edit', match: :prefer_exact

    select @admin_finance_budget.status, from: 'Status'
    select @admin_finance_budget.budget_category, from: 'Budget Category'
    select @admin_finance_budget.event&.title, from: 'Event'
    fill_in "Title", with: @admin_finance_budget.title
    click_on "Update Budget"

    assert_text 'The Budget "Front of House" was successfully updated'
  end

  test "should destroy Budget" do
    visit admin_finance_budget_url(@admin_finance_budget)

    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'The Budget "Front of House" has been successfully destroyed.'
  end
end
