class AssetActivitiesController < ApplicationController
  before_action :sign_in_required
  before_action :set_current_menu

  # GET /asset_activities
  # GET /asset_activities.json
  def index
    asset_id_param = params[:q].present? ? params[:q][:asset_id] : params[:asset_id]
    if asset_id_param.present?
      @asset = Asset.find(asset_id_param)
      current_users_resource_filter(@asset)
      @query = AssetActivity.where(asset_account_id: @asset.asset_accounts.map(&:id)).ransack(params[:q])
      @asset_activities = @query.result.page(params[:page]).per(30).order(transaction_date: :desc)
    end
  end

  private

  def set_current_menu
    @current_menu = :asset
  end
end
