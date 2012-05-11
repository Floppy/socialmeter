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

  def cosm_trigger
    # Decode JSON
    json = JSON.parse(params[:body]) 
    # Check identifier
    environment_id = json['environment']['id']
    datastream_id = json['triggering_datastream']['id']
    if @feed.external_id == "#{environment_id}:#{datastream_id}"
      # Get value in watts
      current_value = json['triggering_datastream']['value']['value'].to_f
      unit = json['triggering_datastream']['units']['symbol']
      # Handle kilowatt feeds
      if unit == 'kW'
        current_value = current_value * 1000
        unit = 'W'
      end
      # Make sure this is an energy feed before we store it
      if unit == 'W'
        @feed.update_attributes(:current_value => current_value)
      end
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
