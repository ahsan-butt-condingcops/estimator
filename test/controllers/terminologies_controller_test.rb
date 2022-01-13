require 'test_helper'

class TerminologiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @terminology = terminologies(:one)
  end

  test "should get index" do
    get terminologies_url
    assert_response :success
  end

  test "should get new" do
    get new_terminology_url
    assert_response :success
  end

  test "should create terminology" do
    assert_difference('Terminology.count') do
      post terminologies_url, params: { terminology: { charge: @terminology.charge, code: @terminology.code, description: @terminology.description, modifier: @terminology.modifier } }
    end

    assert_redirected_to terminology_url(Terminology.last)
  end

  test "should show terminology" do
    get terminology_url(@terminology)
    assert_response :success
  end

  test "should get edit" do
    get edit_terminology_url(@terminology)
    assert_response :success
  end

  test "should update terminology" do
    patch terminology_url(@terminology), params: { terminology: { charge: @terminology.charge, code: @terminology.code, description: @terminology.description, modifier: @terminology.modifier } }
    assert_redirected_to terminology_url(@terminology)
  end

  test "should destroy terminology" do
    assert_difference('Terminology.count', -1) do
      delete terminology_url(@terminology)
    end

    assert_redirected_to terminologies_url
  end
end
