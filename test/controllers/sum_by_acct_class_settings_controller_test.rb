require 'test_helper'

class SumByAcctClassSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sum_by_acct_class_setting = sum_by_acct_class_settings(:one)
  end

  test "should get index" do
    get sum_by_acct_class_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_sum_by_acct_class_setting_url
    assert_response :success
  end

  test "should create sum_by_acct_class_setting" do
    assert_difference('SumByAcctClassSetting.count') do
      post sum_by_acct_class_settings_url, params: { sum_by_acct_class_setting: { sum_by_account_class_id: @sum_by_acct_class_setting.sum_by_account_class_id } }
    end

    assert_redirected_to sum_by_acct_class_setting_url(SumByAcctClassSetting.last)
  end

  test "should show sum_by_acct_class_setting" do
    get sum_by_acct_class_setting_url(@sum_by_acct_class_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_sum_by_acct_class_setting_url(@sum_by_acct_class_setting)
    assert_response :success
  end

  test "should update sum_by_acct_class_setting" do
    patch sum_by_acct_class_setting_url(@sum_by_acct_class_setting), params: { sum_by_acct_class_setting: { sum_by_account_class_id: @sum_by_acct_class_setting.sum_by_account_class_id } }
    assert_redirected_to sum_by_acct_class_setting_url(@sum_by_acct_class_setting)
  end

  test "should destroy sum_by_acct_class_setting" do
    assert_difference('SumByAcctClassSetting.count', -1) do
      delete sum_by_acct_class_setting_url(@sum_by_acct_class_setting)
    end

    assert_redirected_to sum_by_acct_class_settings_url
  end
end
