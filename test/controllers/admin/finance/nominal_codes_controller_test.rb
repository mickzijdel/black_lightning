require "application_integration_test"

class Admin::Finance::NominalCodesControllerTest < ApplicationIntegrationTest
  setup do
    @finance_nominal_code = finance_nominal_codes(:sundry)
    login_as users(:admin)

    @params = {
      finance_nominal_code: {
        active: true,
        code: 123456,
        description: 'A new test nominal code for integration',
        name: 'Integration'
      }
    }
  end

  test "should get index" do
    get admin_finance_nominal_codes_url
    assert_response :success
    assert_not_nil assigns(:nominal_codes)
  end

  test "should get new" do
    get new_admin_finance_nominal_code_url
    assert_response :success
  end

  test "should create finance_nominal_code" do
    assert_difference('Finance::NominalCode.count') do
      post admin_finance_nominal_codes_url, params: @params
    end

    assert_redirected_to admin_finance_nominal_code_url(Finance::NominalCode.last)
  end

  test 'should not create nominal code with same code' do
    @params[:finance_nominal_code][:code] = finance_nominal_codes(:sundry).code

    assert_no_difference('Finance::NominalCode.count') do
      post admin_finance_nominal_codes_url, params: @params
    end

    assert_response :unprocessable_entity
  end

  test "should show finance_nominal_code" do
    get admin_finance_nominal_code_url(@finance_nominal_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_finance_nominal_code_url(@finance_nominal_code)
    assert_response :success
  end

  test "should update finance_nominal_code" do
    patch admin_finance_nominal_code_url(@finance_nominal_code), params: @params
    assert_redirected_to admin_finance_nominal_code_url(@finance_nominal_code)
  end

  test "should not update to code with wrong length" do
    @params[:finance_nominal_code][:code] = '12345'

    patch admin_finance_nominal_code_url(@finance_nominal_code), params: @params
    assert_response :unprocessable_entity
  end

  test "should destroy finance_nominal_code" do
    assert_difference('Finance::NominalCode.count', -1) do
      delete admin_finance_nominal_code_url(@finance_nominal_code)
    end

    assert_redirected_to admin_finance_nominal_codes_url
  end
end
