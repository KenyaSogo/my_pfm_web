require 'test_helper'

class SimulationSummaryByAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @simulation_summary_by_account = simulation_summary_by_accounts(:one)
  end

  test "should get index" do
    get simulation_summary_by_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_simulation_summary_by_account_url
    assert_response :success
  end

  test "should create simulation_summary_by_account" do
    assert_difference('SimulationSummaryByAccount.count') do
      post simulation_summary_by_accounts_url, params: { simulation_summary_by_account: { is_active: @simulation_summary_by_account.is_active, memo: @simulation_summary_by_account.memo, simulation_summary_id: @simulation_summary_by_account.simulation_summary_id } }
    end

    assert_redirected_to simulation_summary_by_account_url(SimulationSummaryByAccount.last)
  end

  test "should show simulation_summary_by_account" do
    get simulation_summary_by_account_url(@simulation_summary_by_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_simulation_summary_by_account_url(@simulation_summary_by_account)
    assert_response :success
  end

  test "should update simulation_summary_by_account" do
    patch simulation_summary_by_account_url(@simulation_summary_by_account), params: { simulation_summary_by_account: { is_active: @simulation_summary_by_account.is_active, memo: @simulation_summary_by_account.memo, simulation_summary_id: @simulation_summary_by_account.simulation_summary_id } }
    assert_redirected_to simulation_summary_by_account_url(@simulation_summary_by_account)
  end

  test "should destroy simulation_summary_by_account" do
    assert_difference('SimulationSummaryByAccount.count', -1) do
      delete simulation_summary_by_account_url(@simulation_summary_by_account)
    end

    assert_redirected_to simulation_summary_by_accounts_url
  end
end
