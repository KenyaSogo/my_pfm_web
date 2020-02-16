require 'test_helper'

class SimulationEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @simulation_entry = simulation_entries(:one)
  end

  test "should get index" do
    get simulation_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_simulation_entry_url
    assert_response :success
  end

  test "should create simulation_entry" do
    assert_difference('SimulationEntry.count') do
      post simulation_entries_url, params: { simulation_entry: { apply_from: @simulation_entry.apply_from, apply_to: @simulation_entry.apply_to, name: @simulation_entry.name, simulation_entry_type_id: @simulation_entry.simulation_entry_type_id, simulation_id: @simulation_entry.simulation_id } }
    end

    assert_redirected_to simulation_entry_url(SimulationEntry.last)
  end

  test "should show simulation_entry" do
    get simulation_entry_url(@simulation_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_simulation_entry_url(@simulation_entry)
    assert_response :success
  end

  test "should update simulation_entry" do
    patch simulation_entry_url(@simulation_entry), params: { simulation_entry: { apply_from: @simulation_entry.apply_from, apply_to: @simulation_entry.apply_to, name: @simulation_entry.name, simulation_entry_type_id: @simulation_entry.simulation_entry_type_id, simulation_id: @simulation_entry.simulation_id } }
    assert_redirected_to simulation_entry_url(@simulation_entry)
  end

  test "should destroy simulation_entry" do
    assert_difference('SimulationEntry.count', -1) do
      delete simulation_entry_url(@simulation_entry)
    end

    assert_redirected_to simulation_entries_url
  end
end
