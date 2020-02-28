require 'test_helper'

class GamestatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gamestate = gamestates(:one)
  end

  test "should get index" do
    get gamestates_url
    assert_response :success
  end

  test "should get new" do
    get new_gamestate_url
    assert_response :success
  end

  test "should create gamestate" do
    assert_difference('Gamestate.count') do
      post gamestates_url, params: { gamestate: { game_id: @gamestate.game_id, hero_id: @gamestate.hero_id, user_id: @gamestate.user_id } }
    end

    assert_redirected_to gamestate_url(Gamestate.last)
  end

  test "should show gamestate" do
    get gamestate_url(@gamestate)
    assert_response :success
  end

  test "should get edit" do
    get edit_gamestate_url(@gamestate)
    assert_response :success
  end

  test "should update gamestate" do
    patch gamestate_url(@gamestate), params: { gamestate: { game_id: @gamestate.game_id, hero_id: @gamestate.hero_id, user_id: @gamestate.user_id } }
    assert_redirected_to gamestate_url(@gamestate)
  end

  test "should destroy gamestate" do
    assert_difference('Gamestate.count', -1) do
      delete gamestate_url(@gamestate)
    end

    assert_redirected_to gamestates_url
  end
end
