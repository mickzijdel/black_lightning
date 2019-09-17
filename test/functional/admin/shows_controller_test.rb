require 'test_helper'

class Admin::ShowsControllerTest < ActionController::TestCase
  setup do
    sign_in FactoryGirl.create(:admin)

    @user = FactoryGirl.create(:member)
  end

  test 'should get index' do
    FactoryGirl.create_list(:show, 10)

    get :index
    assert_response :success
    assert_not_nil assigns(:shows)
  end

  test 'should get show' do
    @show = FactoryGirl.create(:show)

    get :show, params: { id: @show}
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create show' do
    @show = FactoryGirl.build(:show)

    assert_difference('Show.count') do
      post :create, params: {show: { name: @show.name, slug: @show.slug, tagline: @show.tagline, description: @show.description } }
    end

    assert_redirected_to admin_show_path(assigns(:show))
  end

  test 'should get edit' do
    @show = FactoryGirl.create(:show)

    get :edit, params: { id: @show}
    assert_response :success
  end

  test 'should update show' do
    @show = FactoryGirl.create(:show)

    put :update, params: {id: @show, show: { name: @show.name, slug: @show.slug, tagline: @show.tagline, description: @show.description }}
    assert_redirected_to admin_show_path(@show)
  end

  test 'should destroy show' do
    @show = FactoryGirl.create(:show)

    assert_difference('Show.count', -1) do
      delete :destroy, params: { id: @show}
    end

    assert_redirected_to admin_shows_path
  end
end
