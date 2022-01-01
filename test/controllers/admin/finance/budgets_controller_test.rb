require 'application_integration_test'

class Admin::Finance::BudgetsControllerTest < ApplicationIntegrationTest
  include ActionView::Helpers::SanitizeHelper

  setup do
    @admin_finance_budget = finance_budgets(:front_of_house)

    login_as users(:admin)

    @params = {
      finance_budget: {
        budget_category: 'Committee',
        status: 'Initial',
        title: 'Marketing Manager',
        notes: 'This is for A0 posters mainly.'
      }
    }
  end

  test 'should get index' do
    get admin_finance_budgets_url
    assert_response :success
    assert_not_nil assigns(:budgets)
  end

  test 'should get new' do
    get new_admin_finance_budget_url
    assert_response :success
  end

  test 'should create budget' do

    assert_difference('Finance::Budget.count') do
      post admin_finance_budgets_url, params: @params
    end

    assert_redirected_to admin_finance_budget_url(assigns(:budget))
  end

  test 'should not create budget when invalid' do
    @params[:finance_budget][:title] = ''

    assert_no_difference('Finance::Budget.count') do
      post admin_finance_budgets_url, params: @params
    end

    assert_response :unprocessable_entity
  end

  test 'should show budget' do
    get admin_finance_budget_url(@admin_finance_budget)
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_finance_budget_url(@admin_finance_budget)
    assert_response :success
  end

  test 'should update budget' do
    put admin_finance_budget_url(@admin_finance_budget), params: @params

    assert_redirected_to admin_finance_budget_url(@admin_finance_budget)
  end

  test 'should not update budget when invalid' do
    @params[:finance_budget][:title] = ''
  
    put admin_finance_budget_url(@admin_finance_budget), params: @params

    assert_response :unprocessable_entity
  end

  test 'should destroy budget' do
    assert_difference('Finance::Budget.count', -1) do
      delete admin_finance_budget_url(@admin_finance_budget)
    end

    assert_redirected_to admin_finance_budgets_url
  end
end
