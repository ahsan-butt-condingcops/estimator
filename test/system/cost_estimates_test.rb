require "application_system_test_case"

class CostEstimatesTest < ApplicationSystemTestCase
  setup do
    @cost_estimate = cost_estimates(:one)
  end

  test "visiting the index" do
    visit cost_estimates_url
    assert_selector "h1", text: "Cost Estimates"
  end

  test "creating a Cost estimate" do
    visit cost_estimates_url
    click_on "New Cost Estimate"

    fill_in "Co ins", with: @cost_estimate.co_ins
    fill_in "Co pay", with: @cost_estimate.co_pay
    fill_in "Date of appointment", with: @cost_estimate.date_of_appointment
    fill_in "Deductable balance", with: @cost_estimate.deductable_balance
    fill_in "Fee schedule", with: @cost_estimate.fee_schedule_id
    fill_in "Out of pocket max balance", with: @cost_estimate.out_of_pocket_max_balance
    fill_in "Patient name", with: @cost_estimate.patient_name
    fill_in "Plan name", with: @cost_estimate.plan_name
    fill_in "Plan type", with: @cost_estimate.plan_type
    fill_in "Visit template", with: @cost_estimate.visit_template_id
    click_on "Create Cost estimate"

    assert_text "Cost estimate was successfully created"
    click_on "Back"
  end

  test "updating a Cost estimate" do
    visit cost_estimates_url
    click_on "Edit", match: :first

    fill_in "Co ins", with: @cost_estimate.co_ins
    fill_in "Co pay", with: @cost_estimate.co_pay
    fill_in "Date of appointment", with: @cost_estimate.date_of_appointment
    fill_in "Deductable balance", with: @cost_estimate.deductable_balance
    fill_in "Fee schedule", with: @cost_estimate.fee_schedule_id
    fill_in "Out of pocket max balance", with: @cost_estimate.out_of_pocket_max_balance
    fill_in "Patient name", with: @cost_estimate.patient_name
    fill_in "Plan name", with: @cost_estimate.plan_name
    fill_in "Plan type", with: @cost_estimate.plan_type
    fill_in "Visit template", with: @cost_estimate.visit_template_id
    click_on "Update Cost estimate"

    assert_text "Cost estimate was successfully updated"
    click_on "Back"
  end

  test "destroying a Cost estimate" do
    visit cost_estimates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cost estimate was successfully destroyed"
  end
end
