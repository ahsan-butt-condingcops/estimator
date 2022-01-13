require "application_system_test_case"

class TerminologiesTest < ApplicationSystemTestCase
  setup do
    @terminology = terminologies(:one)
  end

  test "visiting the index" do
    visit terminologies_url
    assert_selector "h1", text: "Terminologies"
  end

  test "creating a Terminology" do
    visit terminologies_url
    click_on "New Terminology"

    fill_in "Charge", with: @terminology.charge
    fill_in "Code", with: @terminology.code
    fill_in "Description", with: @terminology.description
    fill_in "Modifier", with: @terminology.modifier
    click_on "Create Terminology"

    assert_text "Terminology was successfully created"
    click_on "Back"
  end

  test "updating a Terminology" do
    visit terminologies_url
    click_on "Edit", match: :first

    fill_in "Charge", with: @terminology.charge
    fill_in "Code", with: @terminology.code
    fill_in "Description", with: @terminology.description
    fill_in "Modifier", with: @terminology.modifier
    click_on "Update Terminology"

    assert_text "Terminology was successfully updated"
    click_on "Back"
  end

  test "destroying a Terminology" do
    visit terminologies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Terminology was successfully destroyed"
  end
end
