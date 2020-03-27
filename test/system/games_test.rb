require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  setup do
    @game = games(:one)
  end

  test "visiting the index" do
    visit games_url
    assert_selector "h1", text: "Games"
  end

  test "creating a Game" do
    visit games_url
    click_on "New Game"

    fill_in "Admin", with: @game.admin_id
    fill_in "Description", with: @game.description
    fill_in "Game name", with: @game.game_name
    fill_in "Image url", with: @game.image_url
    fill_in "Popularity", with: @game.popularity
    fill_in "Start level", with: @game.start_level_id
    click_on "Create Game"

    assert_text "Game was successfully created"
    click_on "Back"
  end

  test "updating a Game" do
    visit games_url
    click_on "Edit", match: :first

    fill_in "Admin", with: @game.admin_id
    fill_in "Description", with: @game.description
    fill_in "Game name", with: @game.game_name
    fill_in "Image url", with: @game.image_url
    fill_in "Popularity", with: @game.popularity
    fill_in "Start level", with: @game.start_level_id
    click_on "Update Game"

    assert_text "Game was successfully updated"
    click_on "Back"
  end

  test "destroying a Game" do
    visit games_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Game was successfully destroyed"
  end
end
