require 'test_helper'

class SimulationResultActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @simulation_result_activity = simulation_result_activities(:one)
  end

  test "should get index" do
    get simulation_result_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_simulation_result_activity_url
    assert_response :success
  end

  test "should create simulation_result_activity" do
    assert_difference('SimulationResultActivity.count') do
      post simulation_result_activities_url, params: { simulation_result_activity: { amount: @simulation_result_activity.amount, asset_account_id: @simulation_result_activity.asset_account_id, description: @simulation_result_activity.description, is_calculation_target: @simulation_result_activity.is_calculation_target, is_transfer: @simulation_result_activity.is_transfer, item_id: @simulation_result_activity.item_id, simulation_entry_detail_id: @simulation_result_activity.simulation_entry_detail_id, sub_item_id: @simulation_result_activity.sub_item_id, transaction_date: @simulation_result_activity.transaction_date } }
    end

    assert_redirected_to simulation_result_activity_url(SimulationResultActivity.last)
  end

  test "should show simulation_result_activity" do
    get simulation_result_activity_url(@simulation_result_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_simulation_result_activity_url(@simulation_result_activity)
    assert_response :success
  end

  test "should update simulation_result_activity" do
    patch simulation_result_activity_url(@simulation_result_activity), params: { simulation_result_activity: { amount: @simulation_result_activity.amount, asset_account_id: @simulation_result_activity.asset_account_id, description: @simulation_result_activity.description, is_calculation_target: @simulation_result_activity.is_calculation_target, is_transfer: @simulation_result_activity.is_transfer, item_id: @simulation_result_activity.item_id, simulation_entry_detail_id: @simulation_result_activity.simulation_entry_detail_id, sub_item_id: @simulation_result_activity.sub_item_id, transaction_date: @simulation_result_activity.transaction_date } }
    assert_redirected_to simulation_result_activity_url(@simulation_result_activity)
  end

  test "should destroy simulation_result_activity" do
    assert_difference('SimulationResultActivity.count', -1) do
      delete simulation_result_activity_url(@simulation_result_activity)
    end

    assert_redirected_to simulation_result_activities_url
  end
end
