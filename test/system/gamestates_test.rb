require "application_system_test_case"

class GamestatesTest < ApplicationSystemTestCase
  setup do
    @gamestate = gamestates(:one)
  end

  test "visiting the index" do
    visit gamestates_url
    assert_selector "h1", text: "Gamestates"
  end

  test "creating a Gamestate" do
    visit gamestates_url
    click_on "New Gamestate"

    fill_in "Game", with: @gamestate.game_id
    fill_in "Hero", with: @gamestate.hero_id
    fill_in "User", with: @gamestate.user_id
    click_on "Create Gamestate"

    assert_text "Gamestate was successfully created"
    click_on "Back"
  end

  test "updating a Gamestate" do
    visit gamestates_url
    click_on "Edit", match: :first

    fill_in "Game", with: @gamestate.game_id
    fill_in "Hero", with: @gamestate.hero_id
    fill_in "User", with: @gamestate.user_id
    click_on "Update Gamestate"

    assert_text "Gamestate was successfully updated"
    click_on "Back"
  end

  test "destroying a Gamestate" do
    visit gamestates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gamestate was successfully destroyed"
  end
end
