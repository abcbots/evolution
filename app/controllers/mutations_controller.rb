class MutationsController < ApplicationController
  def index
    @mutations = Mutation.all
  end
  
  def show
    @mutation = Mutation.find(params[:id])
  end
  
  def new
    @no_nav = true
    @evolution = Evolution.find(params[:evolution_id])
    @mutation = @evolution.mutations.new
    @mutation.mutation_id = params[:mutation_id]
  end
  
  def create
    @mutation = Mutation.new(params[:mutation])
    if @mutation.save
      flash[:notice] = "Successfully created mutation."
      redirect_to @mutation
    else
      render :action => 'new'
    end
  end
  
  def edit
    @mutation = Mutation.find(params[:id])
  end
  
  def update
    @mutation = Mutation.find(params[:id])
    if @mutation.update_attributes(params[:mutation])
      flash[:notice] = "Successfully updated mutation."
      redirect_to @mutation
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @mutation = Mutation.find(params[:id])
    @mutation.destroy
    flash[:notice] = "Successfully destroyed mutation."
    redirect_to mutations_url
  end
end
