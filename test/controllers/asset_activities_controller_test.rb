require 'test_helper'

class AssetActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asset_activity = asset_activities(:one)
  end

  test "should get index" do
    get asset_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_asset_activity_url
    assert_response :success
  end

  test "should create asset_activity" do
    assert_difference('AssetActivity.count') do
      post asset_activities_url, params: { asset_activity: { amount: @asset_activity.amount, asset_account_id: @asset_activity.asset_account_id, description: @asset_activity.description, is_calculation_target: @asset_activity.is_calculation_target, is_transfer: @asset_activity.is_transfer, item_id: @asset_activity.item_id, sub_item_id: @asset_activity.sub_item_id, transaction_date: @asset_activity.transaction_date } }
    end

    assert_redirected_to asset_activity_url(AssetActivity.last)
  end

  test "should show asset_activity" do
    get asset_activity_url(@asset_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_asset_activity_url(@asset_activity)
    assert_response :success
  end

  test "should update asset_activity" do
    patch asset_activity_url(@asset_activity), params: { asset_activity: { amount: @asset_activity.amount, asset_account_id: @asset_activity.asset_account_id, description: @asset_activity.description, is_calculation_target: @asset_activity.is_calculation_target, is_transfer: @asset_activity.is_transfer, item_id: @asset_activity.item_id, sub_item_id: @asset_activity.sub_item_id, transaction_date: @asset_activity.transaction_date } }
    assert_redirected_to asset_activity_url(@asset_activity)
  end

  test "should destroy asset_activity" do
    assert_difference('AssetActivity.count', -1) do
      delete asset_activity_url(@asset_activity)
    end

    assert_redirected_to asset_activities_url
  end
end
