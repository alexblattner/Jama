require 'test_helper'

class DoorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @door = doors(:one)
  end

  test "should get index" do
    get doors_url
    assert_response :success
  end

  test "should get new" do
    get new_door_url
    assert_response :success
  end

  test "should create door" do
    assert_difference('Door.count') do
      post doors_url, params: { door: { description: @door.description, game_id: @door.game_id, image: @door.image, name: @door.name, next_levels: @door.next_levels, requirement: @door.requirement, result: @door.result } }
    end

    assert_redirected_to door_url(Door.last)
  end

  test "should show door" do
    get door_url(@door)
    assert_response :success
  end

  test "should get edit" do
    get edit_door_url(@door)
    assert_response :success
  end

  test "should update door" do
    patch door_url(@door), params: { door: { description: @door.description, game_id: @door.game_id, image: @door.image, name: @door.name, next_levels: @door.next_levels, requirement: @door.requirement, result: @door.result } }
    assert_redirected_to door_url(@door)
  end

  test "should destroy door" do
    assert_difference('Door.count', -1) do
      delete door_url(@door)
    end

    assert_redirected_to doors_url
  end
end
