require 'test_helper'

class CostEstimatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cost_estimate = cost_estimates(:one)
  end

  test "should get index" do
    get cost_estimates_url
    assert_response :success
  end

  test "should get new" do
    get new_cost_estimate_url
    assert_response :success
  end

  test "should create cost_estimate" do
    assert_difference('CostEstimate.count') do
      post cost_estimates_url, params: { cost_estimate: { co_ins: @cost_estimate.co_ins, co_pay: @cost_estimate.co_pay, date_of_appointment: @cost_estimate.date_of_appointment, deductable_balance: @cost_estimate.deductable_balance, fee_schedule_id: @cost_estimate.fee_schedule_id, out_of_pocket_max_balance: @cost_estimate.out_of_pocket_max_balance, patient_name: @cost_estimate.patient_name, plan_name: @cost_estimate.plan_name, plan_type: @cost_estimate.plan_type, visit_template_id: @cost_estimate.visit_template_id } }
    end

    assert_redirected_to cost_estimate_url(CostEstimate.last)
  end

  test "should show cost_estimate" do
    get cost_estimate_url(@cost_estimate)
    assert_response :success
  end

  test "should get edit" do
    get edit_cost_estimate_url(@cost_estimate)
    assert_response :success
  end

  test "should update cost_estimate" do
    patch cost_estimate_url(@cost_estimate), params: { cost_estimate: { co_ins: @cost_estimate.co_ins, co_pay: @cost_estimate.co_pay, date_of_appointment: @cost_estimate.date_of_appointment, deductable_balance: @cost_estimate.deductable_balance, fee_schedule_id: @cost_estimate.fee_schedule_id, out_of_pocket_max_balance: @cost_estimate.out_of_pocket_max_balance, patient_name: @cost_estimate.patient_name, plan_name: @cost_estimate.plan_name, plan_type: @cost_estimate.plan_type, visit_template_id: @cost_estimate.visit_template_id } }
    assert_redirected_to cost_estimate_url(@cost_estimate)
  end

  test "should destroy cost_estimate" do
    assert_difference('CostEstimate.count', -1) do
      delete cost_estimate_url(@cost_estimate)
    end

    assert_redirected_to cost_estimates_url
  end
end
