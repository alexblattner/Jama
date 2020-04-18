require 'test_helper'

class EventInstancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_instance = event_instances(:one)
  end

  test "should get index" do
    get event_instances_url
    assert_response :success
  end

  test "should get new" do
    get new_event_instance_url
    assert_response :success
  end

  test "should create event_instance" do
    assert_difference('EventInstance.count') do
      post event_instances_url, params: { event_instance: { event_id: @event_instance.event_id, gamestate_id: @event_instance.gamestate_id, level_id: @event_instance.level_id, progress: @event_instance.progress } }
    end

    assert_redirected_to event_instance_url(EventInstance.last)
  end

  test "should show event_instance" do
    get event_instance_url(@event_instance)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_instance_url(@event_instance)
    assert_response :success
  end

  test "should update event_instance" do
    patch event_instance_url(@event_instance), params: { event_instance: { event_id: @event_instance.event_id, gamestate_id: @event_instance.gamestate_id, level_id: @event_instance.level_id, progress: @event_instance.progress } }
    assert_redirected_to event_instance_url(@event_instance)
  end

  test "should destroy event_instance" do
    assert_difference('EventInstance.count', -1) do
      delete event_instance_url(@event_instance)
    end

    assert_redirected_to event_instances_url
  end
end
