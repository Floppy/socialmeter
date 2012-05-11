class UsersController < ApplicationController

  before_filter :get_user, :except => [:index, :new, :create]

  def index
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @users = @user.friends(params[:service])
    @total_value = @users.inject(0){|total, x| total += x.current_value}
    @total_carbon = @users.inject(0){|total, x| total += x.current_carbon}
    @total_average_value = @users.inject(0){|total, x| total += x.average_value}
    @total_average_carbon = @users.inject(0){|total, x| total += x.average_carbon}
    respond_to do |format|
      format.xml
      format.csv {
        @csv_options = { :col_sep => "\t" }
      }
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :action => 'edit'
    end
    redirect_to @user
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.create(params[:user])
    if @user.valid?
      redirect_to @user
    else
      render :action => 'new'
    end
  end

  protected

  def get_user
    @user = User.find(params[:id])
  end

end
