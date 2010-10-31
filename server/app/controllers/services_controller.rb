class ServicesController < ApplicationController

  before_filter :get_user
  before_filter :get_service, :except => [:new, :create]

  def show
    respond_to do |format|
      format.html
    end
  end
  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @service.update_attributes(params[:feed])
      redirect_to [@user, @service]
    else
      render :action => 'edit'
    end
  end

  def new
    @service = Service.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @service = @user.services.create(params[:service])
    if @service.valid?
      redirect_to [@user, @service]
    else
      render :action => 'new'
    end
  end

  protected

  def get_user
    @user = User.find(params[:user_id])
  end

  def get_service
    @service = @user.services.find(params[:id])
  end

end
