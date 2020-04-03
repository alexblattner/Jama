require 'test_helper'

class EventIntancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_intance = event_intances(:one)
  end

  test "should get index" do
    get event_intances_url
    assert_response :success
  end

  test "should get new" do
    get new_event_intance_url
    assert_response :success
  end

  test "should create event_intance" do
    assert_difference('EventIntance.count') do
      post event_intances_url, params: { event_intance: { event_id: @event_intance.event_id, gamestate_id: @event_intance.gamestate_id, level_id: @event_intance.level_id, progress: @event_intance.progress } }
    end

    assert_redirected_to event_intance_url(EventIntance.last)
  end

  test "should show event_intance" do
    get event_intance_url(@event_intance)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_intance_url(@event_intance)
    assert_response :success
  end

  test "should update event_intance" do
    patch event_intance_url(@event_intance), params: { event_intance: { event_id: @event_intance.event_id, gamestate_id: @event_intance.gamestate_id, level_id: @event_intance.level_id, progress: @event_intance.progress } }
    assert_redirected_to event_intance_url(@event_intance)
  end

  test "should destroy event_intance" do
    assert_difference('EventIntance.count', -1) do
      delete event_intance_url(@event_intance)
    end

    assert_redirected_to event_intances_url
  end
end
