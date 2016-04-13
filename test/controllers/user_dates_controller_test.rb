require 'test_helper'

class UserDatesControllerTest < ActionController::TestCase
  setup do
    @user_date = user_dates(:one)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_dates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_date" do
    assert_difference('UserDate.count') do
      post :create, user_date: { meeting_date_id: @user_date.meeting_date_id, user_id: @user_date.user_id }
    end

    assert_redirected_to user_date_path(assigns(:user_date))
  end

  test "should show user_date" do
    get :show, id: @user_date
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_date
    assert_response :success
  end

  test "should update user_date" do
    patch :update, id: @user_date, user_date: { meeting_date_id: @user_date.meeting_date_id, user_id: @user_date.user_id }
    assert_redirected_to user_date_path(assigns(:user_date))
  end

  test "should destroy user_date" do
    assert_difference('UserDate.count', -1) do
      delete :destroy, id: @user_date
    end

    assert_redirected_to user_dates_path
  end
end
