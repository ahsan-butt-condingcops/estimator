require "application_system_test_case"

class VisitTemplatesTest < ApplicationSystemTestCase
  setup do
    @visit_template = visit_templates(:one)
  end

  test "visiting the index" do
    visit visit_templates_url
    assert_selector "h1", text: "Visit Templates"
  end

  test "creating a Visit template" do
    visit visit_templates_url
    click_on "New Visit Template"

    fill_in "Name", with: @visit_template.name
    click_on "Create Visit template"

    assert_text "Visit template was successfully created"
    click_on "Back"
  end

  test "updating a Visit template" do
    visit visit_templates_url
    click_on "Edit", match: :first

    fill_in "Name", with: @visit_template.name
    click_on "Update Visit template"

    assert_text "Visit template was successfully updated"
    click_on "Back"
  end

  test "destroying a Visit template" do
    visit visit_templates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Visit template was successfully destroyed"
  end
end
