class Admin::AccessLogsController < ApplicationController
  before_action :sign_in_required
  before_action :admin_permission_required

  def index
    @access_logs = AccessLog.all.page(params[:page]).per(30).order(id: :desc)
  end
end
