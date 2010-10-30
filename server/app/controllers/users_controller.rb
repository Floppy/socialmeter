class UsersController < ApplicationController

  before_filter :get_user, :except => :index

  def index
    @users = User.find(:all)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.xml
      format.html
    end
  end

  protected

  def get_user
    @user = User.find(params[:id])
  end


end
