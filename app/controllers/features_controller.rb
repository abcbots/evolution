class FeaturesController < ApplicationController
  def index
    @features = Feature.all
  end
  
  def show
    @feature = Feature.find(params[:id])
  end
  
  def new
    @feature = Feature.new
  end
  
  def create
    @feature = Feature.new(params[:feature])
    if @feature.save
      flash[:notice] = "Successfully created feature."
      redirect_to @feature
    else
      render :action => 'new'
    end
  end
  
  def edit
    @feature = Feature.find(params[:id])
  end
  
  def update
    @feature = Feature.find(params[:id])
    if @feature.update_attributes(params[:feature])
      flash[:notice] = "Successfully updated feature."
      redirect_to @feature
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy
    flash[:notice] = "Successfully destroyed feature."
    redirect_to features_url
  end
end
