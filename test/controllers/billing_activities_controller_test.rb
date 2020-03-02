require 'test_helper'

class BillingActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billing_activity = billing_activities(:one)
  end

  test "should get index" do
    get billing_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_billing_activity_url
    assert_response :success
  end

  test "should create billing_activity" do
    assert_difference('BillingActivity.count') do
      post billing_activities_url, params: { billing_activity: { amount: @billing_activity.amount, asset_account_id: @billing_activity.asset_account_id, billing_account_id: @billing_activity.billing_account_id, description: @billing_activity.description, is_calculation_target: @billing_activity.is_calculation_target, is_transfer: @billing_activity.is_transfer, item_id: @billing_activity.item_id, sub_item_id: @billing_activity.sub_item_id, transaction_date: @billing_activity.transaction_date } }
    end

    assert_redirected_to billing_activity_url(BillingActivity.last)
  end

  test "should show billing_activity" do
    get billing_activity_url(@billing_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_billing_activity_url(@billing_activity)
    assert_response :success
  end

  test "should update billing_activity" do
    patch billing_activity_url(@billing_activity), params: { billing_activity: { amount: @billing_activity.amount, asset_account_id: @billing_activity.asset_account_id, billing_account_id: @billing_activity.billing_account_id, description: @billing_activity.description, is_calculation_target: @billing_activity.is_calculation_target, is_transfer: @billing_activity.is_transfer, item_id: @billing_activity.item_id, sub_item_id: @billing_activity.sub_item_id, transaction_date: @billing_activity.transaction_date } }
    assert_redirected_to billing_activity_url(@billing_activity)
  end

  test "should destroy billing_activity" do
    assert_difference('BillingActivity.count', -1) do
      delete billing_activity_url(@billing_activity)
    end

    assert_redirected_to billing_activities_url
  end
end
