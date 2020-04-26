class Admin::UsersController < ApplicationController
  before_action :sign_in_required
  before_action :admin_permission_required

  def index
    @users = User.all.page(params[:page]).per(30).order(id: :asc)
  end

  def show
  end
end
