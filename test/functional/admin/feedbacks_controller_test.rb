require 'test_helper'

class Admin::FeedbacksControllerTest < ActionController::TestCase
  setup do
    @show = FactoryBot.create(:show)

    sign_in FactoryBot.create(:admin)
  end

  test 'should get index' do
    FactoryBot.create_list(:feedback, 10)

    get :index, params: { show_id: @show }
    assert_response :success
    assert_not_nil assigns(:feedbacks), 'The index view did not assign any feedbacks to @feedbacks'
  end

  test 'should get new' do
    get :new, params: { show_id: @show }
    assert_response :success
  end

  test 'should create admin_feedback' do
    @feedback = FactoryBot.attributes_for(:feedback, show: nil)

    assert_difference('Admin::Feedback.count') do
      post :create, params: { show_id: @show, admin_feedback: @feedback }
    end

    assert_redirected_to admin_show_feedbacks_path(@show)
  end

  test 'should create admin_feedback without read permission' do
    #skip 'Setting the sign up permissions is very hard'
    sign_in FactoryBot.create(:member)

    @feedback = FactoryBot.attributes_for(:feedback, show: nil)

    assert_difference('Admin::Feedback.count') do
      post :create, params: { show_id: @show, admin_feedback: @feedback }
    end

    assert_redirected_to admin_show_path(@show)
  end

  test 'should not create admin_feedback that is invalid' do
    @feedback = FactoryBot.attributes_for(:feedback, body: '')

    assert_no_difference('Admin::Feedback.count') do
      post :create, params: { show_id: @show, admin_feedback: @feedback }
    end

    assert_response :unprocessable_entity
  end

  test 'should get edit' do
    @feedback = FactoryBot.create(:feedback, show: @show)

    get :edit, params: { show_id: @show, id: @feedback }
    assert_response :success
  end

  test 'should update admin_feedback' do
    @feedback = FactoryBot.create(:feedback, show: @show)
    @attrs = FactoryBot.attributes_for(:feedback, show: @show)

    put :update, params: { show_id: @show, id: @feedback, admin_feedback: @attrs }
    assert_redirected_to admin_show_feedbacks_path(@show)
  end

  test 'should not update admin_feedback that is invalid' do
    @feedback = FactoryBot.create(:feedback, show: @show)
    @attrs = FactoryBot.attributes_for(:feedback, body: '')

    put :update, params: { show_id: @show, id: @feedback, admin_feedback: @attrs }
    assert_response :unprocessable_entity
  end

  test 'should destroy admin_feedback' do
    @feedback = FactoryBot.create(:feedback, show: @show)

    assert_difference('Admin::Feedback.count', -1) do
      delete :destroy, params: { show_id: @show, id: @feedback }
    end

    assert_redirected_to admin_show_feedbacks_path(@show)
  end
end
