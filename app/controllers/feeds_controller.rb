class FeedsController < ApplicationController

  before_filter :get_user
  before_filter :get_feed, :except => [:new, :create]

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
    if @feed.update_attributes(params[:feed])
      redirect_to [@user, @feed]
    else
      render :action => 'edit'
    end
  end

  def new
    @feed = Feed.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @feed = @user.feeds.create(params[:feed])
    if @feed.valid?
      redirect_to [@user, @feed]
    else
      render :action => 'new'
    end
  end

  protected

  def get_user
    @user = User.find(params[:user_id])
  end

  def get_feed
    @feed = @user.feeds.find(params[:id])
  end

end
