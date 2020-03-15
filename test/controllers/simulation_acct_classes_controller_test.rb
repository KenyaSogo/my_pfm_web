require 'test_helper'

class SimulationAcctClassesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @simulation_acct_class = simulation_acct_classes(:one)
  end

  test "should get index" do
    get simulation_acct_classes_url
    assert_response :success
  end

  test "should get new" do
    get new_simulation_acct_class_url
    assert_response :success
  end

  test "should create simulation_acct_class" do
    assert_difference('SimulationAcctClass.count') do
      post simulation_acct_classes_url, params: { simulation_acct_class: { name: @simulation_acct_class.name, sum_by_acct_class_setting_id: @simulation_acct_class.sum_by_acct_class_setting_id } }
    end

    assert_redirected_to simulation_acct_class_url(SimulationAcctClass.last)
  end

  test "should show simulation_acct_class" do
    get simulation_acct_class_url(@simulation_acct_class)
    assert_response :success
  end

  test "should get edit" do
    get edit_simulation_acct_class_url(@simulation_acct_class)
    assert_response :success
  end

  test "should update simulation_acct_class" do
    patch simulation_acct_class_url(@simulation_acct_class), params: { simulation_acct_class: { name: @simulation_acct_class.name, sum_by_acct_class_setting_id: @simulation_acct_class.sum_by_acct_class_setting_id } }
    assert_redirected_to simulation_acct_class_url(@simulation_acct_class)
  end

  test "should destroy simulation_acct_class" do
    assert_difference('SimulationAcctClass.count', -1) do
      delete simulation_acct_class_url(@simulation_acct_class)
    end

    assert_redirected_to simulation_acct_classes_url
  end
end
