require 'test_helper'

class SummaryByAssetTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @summary_by_asset_type = summary_by_asset_types(:one)
  end

  test "should get index" do
    get summary_by_asset_types_url
    assert_response :success
  end

  test "should get new" do
    get new_summary_by_asset_type_url
    assert_response :success
  end

  test "should create summary_by_asset_type" do
    assert_difference('SummaryByAssetType.count') do
      post summary_by_asset_types_url, params: { summary_by_asset_type: { is_active: @summary_by_asset_type.is_active, memo: @summary_by_asset_type.memo, simulation_summary_id: @summary_by_asset_type.simulation_summary_id, summarized_at: @summary_by_asset_type.summarized_at } }
    end

    assert_redirected_to summary_by_asset_type_url(SummaryByAssetType.last)
  end

  test "should show summary_by_asset_type" do
    get summary_by_asset_type_url(@summary_by_asset_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_summary_by_asset_type_url(@summary_by_asset_type)
    assert_response :success
  end

  test "should update summary_by_asset_type" do
    patch summary_by_asset_type_url(@summary_by_asset_type), params: { summary_by_asset_type: { is_active: @summary_by_asset_type.is_active, memo: @summary_by_asset_type.memo, simulation_summary_id: @summary_by_asset_type.simulation_summary_id, summarized_at: @summary_by_asset_type.summarized_at } }
    assert_redirected_to summary_by_asset_type_url(@summary_by_asset_type)
  end

  test "should destroy summary_by_asset_type" do
    assert_difference('SummaryByAssetType.count', -1) do
      delete summary_by_asset_type_url(@summary_by_asset_type)
    end

    assert_redirected_to summary_by_asset_types_url
  end
end
