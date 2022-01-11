require "application_integration_test"

class Admin::Finance::TransactionCategoriesControllerTest < ApplicationIntegrationTest
  setup do
    @admin_finance_transaction_category = finance_transaction_categories(:tech)

    login_as users(:admin)

    @params = {

      finance_transaction_category: {
        active: true,
        description: 'For set and tool hire but this is a long description',
        hint: 'For set and tool hire',
        name: 'Set',
        nominal_code_id: finance_nominal_codes(:set_and_tech).id,
        transaction_type: 'expense'
      }
    }
  end

  test "should get index" do
    get admin_finance_transaction_categories_url
    assert_response :success
    assert_not_nil assigns(:transaction_categories)
  end

  test "should get new" do
    get new_admin_finance_transaction_category_url
    assert_response :success
  end

  test "should create transaction_category" do
    assert_difference("Finance::TransactionCategory.count") do
      post admin_finance_transaction_categories_url, params: @params
    end

    assert_redirected_to admin_finance_transaction_category_url(assigns(:transaction_category))
  end

  test "should not create transaction_category when invalid" do
    @params[:finance_transaction_category][:name] = @admin_finance_transaction_category.name

    assert_no_difference("Finance::TransactionCategory.count") do
      post admin_finance_transaction_categories_url, params: @params
    end

    assert_response :unprocessable_entity
  end

  test "should show transaction_category" do
    get admin_finance_transaction_category_url(@admin_finance_transaction_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_finance_transaction_category_url(@admin_finance_transaction_category)
    assert_response :success
  end

  test "should update transaction_category" do
    patch admin_finance_transaction_category_url(@admin_finance_transaction_category), params: @params
    assert_redirected_to admin_finance_transaction_category_url(@admin_finance_transaction_category)
  end

  test "should not update transaction_category when invalid" do
    @params[:finance_transaction_category][:hint] = nil

    patch admin_finance_transaction_category_url(@admin_finance_transaction_category), params: @params
    assert_response :unprocessable_entity
  end

  test "should destroy transaction_category" do
    assert_difference("Finance::TransactionCategory.count", -1) do
      delete admin_finance_transaction_category_url(@admin_finance_transaction_category)
    end

    assert_redirected_to admin_finance_transaction_categories_url
  end
end
