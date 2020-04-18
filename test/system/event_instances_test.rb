require "application_system_test_case"

class EventInstancesTest < ApplicationSystemTestCase
  setup do
    @event_instance = event_instances(:one)
  end

  test "visiting the index" do
    visit event_instances_url
    assert_selector "h1", text: "Event Instances"
  end

  test "creating a Event instance" do
    visit event_instances_url
    click_on "New Event Instance"

    fill_in "Event", with: @event_instance.event_id
    fill_in "Gamestate", with: @event_instance.gamestate_id
    fill_in "Level", with: @event_instance.level_id
    fill_in "Progress", with: @event_instance.progress
    click_on "Create Event instance"

    assert_text "Event instance was successfully created"
    click_on "Back"
  end

  test "updating a Event instance" do
    visit event_instances_url
    click_on "Edit", match: :first

    fill_in "Event", with: @event_instance.event_id
    fill_in "Gamestate", with: @event_instance.gamestate_id
    fill_in "Level", with: @event_instance.level_id
    fill_in "Progress", with: @event_instance.progress
    click_on "Update Event instance"

    assert_text "Event instance was successfully updated"
    click_on "Back"
  end

  test "destroying a Event instance" do
    visit event_instances_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Event instance was successfully destroyed"
  end
end
