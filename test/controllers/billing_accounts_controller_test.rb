require 'test_helper'

class BillingAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billing_account = billing_accounts(:one)
  end

  test "should get index" do
    get billing_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_billing_account_url
    assert_response :success
  end

  test "should create billing_account" do
    assert_difference('BillingAccount.count') do
      post billing_accounts_url, params: { billing_account: { billing_closing_day: @billing_account.billing_closing_day, billing_item_id: @billing_account.billing_item_id, billing_sub_item_id: @billing_account.billing_sub_item_id, credit_account_id: @billing_account.credit_account_id, debit_account_id: @billing_account.debit_account_id, debit_item_id: @billing_account.debit_item_id, debit_sub_item_id: @billing_account.debit_sub_item_id, simulation_id: @billing_account.simulation_id, withdrawal_day: @billing_account.withdrawal_day, withdrawal_month_offset: @billing_account.withdrawal_month_offset } }
    end

    assert_redirected_to billing_account_url(BillingAccount.last)
  end

  test "should show billing_account" do
    get billing_account_url(@billing_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_billing_account_url(@billing_account)
    assert_response :success
  end

  test "should update billing_account" do
    patch billing_account_url(@billing_account), params: { billing_account: { billing_closing_day: @billing_account.billing_closing_day, billing_item_id: @billing_account.billing_item_id, billing_sub_item_id: @billing_account.billing_sub_item_id, credit_account_id: @billing_account.credit_account_id, debit_account_id: @billing_account.debit_account_id, debit_item_id: @billing_account.debit_item_id, debit_sub_item_id: @billing_account.debit_sub_item_id, simulation_id: @billing_account.simulation_id, withdrawal_day: @billing_account.withdrawal_day, withdrawal_month_offset: @billing_account.withdrawal_month_offset } }
    assert_redirected_to billing_account_url(@billing_account)
  end

  test "should destroy billing_account" do
    assert_difference('BillingAccount.count', -1) do
      delete billing_account_url(@billing_account)
    end

    assert_redirected_to billing_accounts_url
  end
end
