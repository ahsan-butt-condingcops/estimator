require 'test_helper'

class FeeSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fee_schedule = fee_schedules(:one)
  end

  test "should get index" do
    get fee_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_fee_schedule_url
    assert_response :success
  end

  test "should create fee_schedule" do
    assert_difference('FeeSchedule.count') do
      post fee_schedules_url, params: { fee_schedule: { name: @fee_schedule.name } }
    end

    assert_redirected_to fee_schedule_url(FeeSchedule.last)
  end

  test "should show fee_schedule" do
    get fee_schedule_url(@fee_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_fee_schedule_url(@fee_schedule)
    assert_response :success
  end

  test "should update fee_schedule" do
    patch fee_schedule_url(@fee_schedule), params: { fee_schedule: { name: @fee_schedule.name } }
    assert_redirected_to fee_schedule_url(@fee_schedule)
  end

  test "should destroy fee_schedule" do
    assert_difference('FeeSchedule.count', -1) do
      delete fee_schedule_url(@fee_schedule)
    end

    assert_redirected_to fee_schedules_url
  end
end
