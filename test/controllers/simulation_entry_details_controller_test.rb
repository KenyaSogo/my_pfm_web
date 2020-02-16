require 'test_helper'

class SimulationEntryDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @simulation_entry_detail = simulation_entry_details(:one)
  end

  test "should get index" do
    get simulation_entry_details_url
    assert_response :success
  end

  test "should get new" do
    get new_simulation_entry_detail_url
    assert_response :success
  end

  test "should create simulation_entry_detail" do
    assert_difference('SimulationEntryDetail.count') do
      post simulation_entry_details_url, params: { simulation_entry_detail: { amount: @simulation_entry_detail.amount, asset_account_id: @simulation_entry_detail.asset_account_id, description: @simulation_entry_detail.description, is_calculation_target: @simulation_entry_detail.is_calculation_target, is_transfer: @simulation_entry_detail.is_transfer, item_id: @simulation_entry_detail.item_id, simulation_entry_id: @simulation_entry_detail.simulation_entry_id, sub_item_id: @simulation_entry_detail.sub_item_id, transaction_date_day: @simulation_entry_detail.transaction_date_day, transaction_date_month: @simulation_entry_detail.transaction_date_month, transaction_date_weekday: @simulation_entry_detail.transaction_date_weekday, transaction_date_year: @simulation_entry_detail.transaction_date_year } }
    end

    assert_redirected_to simulation_entry_detail_url(SimulationEntryDetail.last)
  end

  test "should show simulation_entry_detail" do
    get simulation_entry_detail_url(@simulation_entry_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_simulation_entry_detail_url(@simulation_entry_detail)
    assert_response :success
  end

  test "should update simulation_entry_detail" do
    patch simulation_entry_detail_url(@simulation_entry_detail), params: { simulation_entry_detail: { amount: @simulation_entry_detail.amount, asset_account_id: @simulation_entry_detail.asset_account_id, description: @simulation_entry_detail.description, is_calculation_target: @simulation_entry_detail.is_calculation_target, is_transfer: @simulation_entry_detail.is_transfer, item_id: @simulation_entry_detail.item_id, simulation_entry_id: @simulation_entry_detail.simulation_entry_id, sub_item_id: @simulation_entry_detail.sub_item_id, transaction_date_day: @simulation_entry_detail.transaction_date_day, transaction_date_month: @simulation_entry_detail.transaction_date_month, transaction_date_weekday: @simulation_entry_detail.transaction_date_weekday, transaction_date_year: @simulation_entry_detail.transaction_date_year } }
    assert_redirected_to simulation_entry_detail_url(@simulation_entry_detail)
  end

  test "should destroy simulation_entry_detail" do
    assert_difference('SimulationEntryDetail.count', -1) do
      delete simulation_entry_detail_url(@simulation_entry_detail)
    end

    assert_redirected_to simulation_entry_details_url
  end
end
