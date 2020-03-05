require 'test_helper'

class SimulationSummariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @simulation_summary = simulation_summaries(:one)
  end

  test "should get index" do
    get simulation_summaries_url
    assert_response :success
  end

  test "should get new" do
    get new_simulation_summary_url
    assert_response :success
  end

  test "should create simulation_summary" do
    assert_difference('SimulationSummary.count') do
      post simulation_summaries_url, params: { simulation_summary: { simulation_id: @simulation_summary.simulation_id, summarized_at: @simulation_summary.summarized_at } }
    end

    assert_redirected_to simulation_summary_url(SimulationSummary.last)
  end

  test "should show simulation_summary" do
    get simulation_summary_url(@simulation_summary)
    assert_response :success
  end

  test "should get edit" do
    get edit_simulation_summary_url(@simulation_summary)
    assert_response :success
  end

  test "should update simulation_summary" do
    patch simulation_summary_url(@simulation_summary), params: { simulation_summary: { simulation_id: @simulation_summary.simulation_id, summarized_at: @simulation_summary.summarized_at } }
    assert_redirected_to simulation_summary_url(@simulation_summary)
  end

  test "should destroy simulation_summary" do
    assert_difference('SimulationSummary.count', -1) do
      delete simulation_summary_url(@simulation_summary)
    end

    assert_redirected_to simulation_summaries_url
  end
end
