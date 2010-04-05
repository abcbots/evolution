class EvolutionPrioritiesController < ApplicationController
  def index
    @evolution_priorities = EvolutionPriority.all
  end
  
  def show
    @evolution_priority = EvolutionPriority.find(params[:id])
  end
  
  def new
    @evolution_priority = EvolutionPriority.new
  end
  
  def create
    @evolution_priority = EvolutionPriority.new(params[:evolution_priority])
    if @evolution_priority.save
      flash[:notice] = "Successfully created evolution priority."
      redirect_to @evolution_priority
    else
      render :action => 'new'
    end
  end
  
  def edit
    @evolution_priority = EvolutionPriority.find(params[:id])
  end
  
  def update
    @evolution_priority = EvolutionPriority.find(params[:id])
    if @evolution_priority.update_attributes(params[:evolution_priority])
      flash[:notice] = "Successfully updated evolution priority."
      redirect_to @evolution_priority
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @evolution_priority = EvolutionPriority.find(params[:id])
    @evolution_priority.destroy
    flash[:notice] = "Successfully destroyed evolution priority."
    redirect_to evolution_priorities_url
  end
end
