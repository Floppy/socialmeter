class UsersController < ApplicationController

  before_filter :get_user

  def show
    respond_to do |format|
      format.xml
    end
  end

  protected

  def get_user
    @user = User.find(params[:id])
  end


end
