require "application_system_test_case"

class EventIntancesTest < ApplicationSystemTestCase
  setup do
    @event_intance = event_intances(:one)
  end

  test "visiting the index" do
    visit event_intances_url
    assert_selector "h1", text: "Event Intances"
  end

  test "creating a Event intance" do
    visit event_intances_url
    click_on "New Event Intance"

    fill_in "Event", with: @event_intance.event_id
    fill_in "Gamestate", with: @event_intance.gamestate_id
    fill_in "Level", with: @event_intance.level_id
    fill_in "Progress", with: @event_intance.progress
    click_on "Create Event intance"

    assert_text "Event intance was successfully created"
    click_on "Back"
  end

  test "updating a Event intance" do
    visit event_intances_url
    click_on "Edit", match: :first

    fill_in "Event", with: @event_intance.event_id
    fill_in "Gamestate", with: @event_intance.gamestate_id
    fill_in "Level", with: @event_intance.level_id
    fill_in "Progress", with: @event_intance.progress
    click_on "Update Event intance"

    assert_text "Event intance was successfully updated"
    click_on "Back"
  end

  test "destroying a Event intance" do
    visit event_intances_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Event intance was successfully destroyed"
  end
end
