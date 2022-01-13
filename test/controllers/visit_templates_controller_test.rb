require 'test_helper'

class VisitTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visit_template = visit_templates(:one)
  end

  test "should get index" do
    get visit_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_visit_template_url
    assert_response :success
  end

  test "should create visit_template" do
    assert_difference('VisitTemplate.count') do
      post visit_templates_url, params: { visit_template: { name: @visit_template.name } }
    end

    assert_redirected_to visit_template_url(VisitTemplate.last)
  end

  test "should show visit_template" do
    get visit_template_url(@visit_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_visit_template_url(@visit_template)
    assert_response :success
  end

  test "should update visit_template" do
    patch visit_template_url(@visit_template), params: { visit_template: { name: @visit_template.name } }
    assert_redirected_to visit_template_url(@visit_template)
  end

  test "should destroy visit_template" do
    assert_difference('VisitTemplate.count', -1) do
      delete visit_template_url(@visit_template)
    end

    assert_redirected_to visit_templates_url
  end
end
