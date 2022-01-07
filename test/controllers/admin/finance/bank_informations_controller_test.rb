require 'application_integration_test'

class Admin::Finance::BankInformationsControllerTest < ApplicationIntegrationTest
  setup do
    @admin_finance_bank_information = finance_bank_informations(:with_user)

    login_as users(:admin)

    # You must update these to not directly copy the fixture but put in original data.
    @params = {
      finance_bank_information: {
        account_holder_name: 'Controller Beregard',
        account_number: '75849855',
        sort_code: '200052'
      }
    }
  end

  test 'should get index' do
    get admin_finance_bank_informations_url
    assert_response :success
    assert_not_nil assigns(:bank_informations)
  end

  test 'should get new' do
    get new_admin_finance_bank_information_url
    assert_response :success
  end

  test 'should create bank_information' do
    assert_difference('Finance::BankInformation.count') do
      post admin_finance_bank_informations_url, params: @params

      p response.body
    end

    assert_redirected_to admin_finance_bank_information_url(assigns(:bank_information))
  end

  test 'should not create bank_information when invalid' do
    @params[:finance_bank_information][:account_holder_name] = nil

    assert_no_difference('Finance::BankInformation.count') do
      post admin_finance_bank_informations_url, params: @params
    end

    assert_response :unprocessable_entity
  end

  test 'should show bank_information' do
    get admin_finance_bank_information_url(@admin_finance_bank_information)
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_finance_bank_information_url(@admin_finance_bank_information)
    assert_response :success
  end

  test 'should update bank_information' do
    patch admin_finance_bank_information_url(@admin_finance_bank_information), params: @params

    p response.body

    assert_redirected_to admin_finance_bank_information_url(@admin_finance_bank_information)
  end

  test 'should not update bank_information when invalid' do
    @params[:finance_bank_information][:sort_code] = '000'

    patch admin_finance_bank_information_url(@admin_finance_bank_information), params: @params
    assert_response :unprocessable_entity
  end

  test 'should destroy bank_information' do
    assert_difference('Finance::BankInformation.count', -1) do
      delete admin_finance_bank_information_url(@admin_finance_bank_information)
    end

    assert_redirected_to admin_finance_bank_informations_url
  end
end
