require 'test_helper'

class SumByAccountClassesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sum_by_account_class = sum_by_account_classes(:one)
  end

  test "should get index" do
    get sum_by_account_classes_url
    assert_response :success
  end

  test "should get new" do
    get new_sum_by_account_class_url
    assert_response :success
  end

  test "should create sum_by_account_class" do
    assert_difference('SumByAccountClass.count') do
      post sum_by_account_classes_url, params: { sum_by_account_class: { is_active: @sum_by_account_class.is_active, memo: @sum_by_account_class.memo, name: @sum_by_account_class.name, simulation_summary_id: @sum_by_account_class.simulation_summary_id, summarized_at: @sum_by_account_class.summarized_at } }
    end

    assert_redirected_to sum_by_account_class_url(SumByAccountClass.last)
  end

  test "should show sum_by_account_class" do
    get sum_by_account_class_url(@sum_by_account_class)
    assert_response :success
  end

  test "should get edit" do
    get edit_sum_by_account_class_url(@sum_by_account_class)
    assert_response :success
  end

  test "should update sum_by_account_class" do
    patch sum_by_account_class_url(@sum_by_account_class), params: { sum_by_account_class: { is_active: @sum_by_account_class.is_active, memo: @sum_by_account_class.memo, name: @sum_by_account_class.name, simulation_summary_id: @sum_by_account_class.simulation_summary_id, summarized_at: @sum_by_account_class.summarized_at } }
    assert_redirected_to sum_by_account_class_url(@sum_by_account_class)
  end

  test "should destroy sum_by_account_class" do
    assert_difference('SumByAccountClass.count', -1) do
      delete sum_by_account_class_url(@sum_by_account_class)
    end

    assert_redirected_to sum_by_account_classes_url
  end
end
