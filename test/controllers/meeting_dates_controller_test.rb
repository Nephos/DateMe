require 'test_helper'

class MeetingDatesControllerTest < ActionController::TestCase
  setup do
    @meeting_date = meeting_dates(:one)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meeting_dates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meeting_date" do
    assert_difference('MeetingDate.count') do
      post :create, meeting_date: { date: @meeting_date.date, meeting_uuid: @meeting_date.meeting_uuid, note: @meeting_date.note }
    end

    assert_redirected_to meeting_date_path(assigns(:meeting_date))
  end

  test "should show meeting_date" do
    get :show, id: @meeting_date
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meeting_date
    assert_response :success
  end

  test "should update meeting_date" do
    patch :update, id: @meeting_date, meeting_date: { date: @meeting_date.date, meeting_uuid: @meeting_date.meeting_uuid, note: @meeting_date.note }
    assert_redirected_to meeting_date_path(assigns(:meeting_date))
  end

  test "should destroy meeting_date" do
    assert_difference('MeetingDate.count', -1) do
      delete :destroy, id: @meeting_date
    end

    assert_redirected_to meeting_dates_path
  end
end
