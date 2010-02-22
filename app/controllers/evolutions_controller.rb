class EvolutionsController < ApplicationController
  def index
    @evolutions = Evolution.all
  end
  
  def show
    @evolution = Evolution.find(params[:id])
  end
  
  def new
    @no_nav = true
    @evolution = Evolution.new
    @evolution.evolution_id = params[:evolution_id]
  end
  
  def create
    @evolution = Evolution.new(params[:evolution])
    if @evolution.save
      flash[:notice] = "Successfully created evolution."
      redirect_to @evolution
    else
      render :action => 'new'
    end
  end
  
  def edit
    @evolution = Evolution.find(params[:id])
  end
  
  def update
    @evolution = Evolution.find(params[:id])
    if @evolution.update_attributes(params[:evolution])
      flash[:notice] = "Successfully updated evolution."
      redirect_to @evolution
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @evolution = Evolution.find(params[:id])
    @evolution.destroy
    flash[:notice] = "Successfully destroyed evolution."
    redirect_to evolutions_url
  end
end
