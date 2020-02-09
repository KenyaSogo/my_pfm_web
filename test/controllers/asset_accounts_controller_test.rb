require 'test_helper'

class AssetAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asset_account = asset_accounts(:one)
  end

  test "should get index" do
    get asset_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_asset_account_url
    assert_response :success
  end

  test "should create asset_account" do
    assert_difference('AssetAccount.count') do
      post asset_accounts_url, params: { asset_account: { asset_id: @asset_account.asset_id, name: @asset_account.name, type_id: @asset_account.type_id } }
    end

    assert_redirected_to asset_account_url(AssetAccount.last)
  end

  test "should show asset_account" do
    get asset_account_url(@asset_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_asset_account_url(@asset_account)
    assert_response :success
  end

  test "should update asset_account" do
    patch asset_account_url(@asset_account), params: { asset_account: { asset_id: @asset_account.asset_id, name: @asset_account.name, type_id: @asset_account.type_id } }
    assert_redirected_to asset_account_url(@asset_account)
  end

  test "should destroy asset_account" do
    assert_difference('AssetAccount.count', -1) do
      delete asset_account_url(@asset_account)
    end

    assert_redirected_to asset_accounts_url
  end
end
