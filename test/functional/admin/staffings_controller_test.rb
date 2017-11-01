require 'test_helper'

class Admin::StaffingsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:admin)
    sign_in @user

    # Turn on delayed jobs for staffings - the staffing mailer refers to the job.
    Delayed::Worker.delay_jobs = true
  end

  teardown do
    # Turn off delayed jobs back off
    Delayed::Worker.delay_jobs = false
  end

  test 'should get index' do
    FactoryGirl.create_list(:staffing, 10, job_count: 5)

    get :index
    assert_response :success
    assert_not_nil assigns(:admin_staffings)
  end

  test 'should get grid' do
    FactoryGirl.create_list(:staffing, 10, job_count: 5, show_title: 'Test')

    get :grid, show_title: 'Test'
    assert_response :success
    assert_not_nil assigns(:staffings)
    assert_not_nil assigns(:staffings_hash)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create admin_staffing' do
    attrs = FactoryGirl.attributes_for(:staffing)

    assert_difference('Admin::Staffing.count') do
      post :create, admin_staffing: attrs
    end

    assert_redirected_to admin_staffing_path(assigns(:admin_staffing))
  end

  test 'should show admin_staffing' do
    @staffing = FactoryGirl.create(:staffing, job_count: 5)

    get :show, id: @staffing
    assert_response :success
  end

  test 'should get edit' do
    @staffing = FactoryGirl.create(:staffing, job_count: 5)

    get :edit, id: @staffing
    assert_response :success
  end

  test 'should update admin_staffing' do
    @staffing = FactoryGirl.create(:staffing, job_count: 5)
    attrs = FactoryGirl.attributes_for(:staffing)

    put :update, id: @staffing, admin_staffing: attrs
    assert_redirected_to admin_staffing_path(assigns(:admin_staffing))
  end

  test 'should destroy admin_staffing' do
    @staffing = FactoryGirl.create(:staffing, job_count: 5)

    assert_difference('Admin::Staffing.count', -1) do
      assert_difference('Admin::StaffingJob.count', -5) do
        delete :destroy, id: @staffing
      end
    end

    assert_redirected_to admin_staffings_path
  end

  test 'should get sign_up_page' do
    @staffing = FactoryGirl.create(:staffing, job_count: 5)

    get :show_sign_up, id: @staffing
    assert_response :success
  end

  test 'should get sign_up_confirm' do
    @staffing = FactoryGirl.create(:staffing, job_count: 5)

    get :sign_up_confirm, id: @staffing.staffing_jobs.first
    assert_response :success
  end

  test 'should put sign_up' do
    @user = FactoryGirl.create(:member_with_phone_number)
    sign_in @user
    print(@user.phone_number)

    @staffing = FactoryGirl.create(:staffing, job_count: 5)
    @job = @staffing.staffing_jobs.first

    put :sign_up, id: @job
    assert_redirected_to admin_staffings_path

    assert_equal Admin::StaffingJob.find(@job.id).user_id, @user.id
  end
end
