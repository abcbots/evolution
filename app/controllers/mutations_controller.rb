class MutationsController < ApplicationController
  def index
    @evolution = Evolution.find(params[:evolution_id])
    @mutations = @evolution.mutations.all
  end
  
  def show
    mutation = Mutation.find(params[:id])
    if mutation.evolution_id
      @evolution = Evolution.find(mutation.evolution_id)
      @mutation = @evolution.mutations.find(params[:id])
    else
      mutation_node = mutation.ancestors.last
      @evolution = Evolution.find(mutation_node.evolution_id)
      @mutation = Mutation.find(params[:id])
    end
  end
  
  def new
    @no_links = true
    if params[:mutation_id]
      mutation = Mutation.find(params[:mutation_id])
      if mutation.evolution_id
        @evolution = Evolution.find(mutation.evolution_id)
        @mutation = Mutation.new
        @mutation.mutation_id = params[:mutation_id]
      else
        mutation = mutation.ancestors.last
        @evolution = Evolution.find(mutation.evolution_id)
        @mutation = Mutation.new
        @mutation.mutation_id = params[:mutation_id]
      end
    else
      @evolution = Evolution.find(params[:evolution_id])
      @mutation = @evolution.mutations.new
      @mutation.evolution_id = params[:evolution_id]
    end
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
    get_evolution_from_mutation
    @mutation = @evolution.mutations.find(params[:id])
  end
  
  def update
    get_evolution_from_mutation
    @mutation = @evolution.mutations.find(params[:id])
    if @mutation.update_attributes(params[:mutation])
      flash[:notice] = "Successfully updated mutation."
      redirect_to @mutation
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    get_evolution_from_mutation
    @mutation = @evolution.mutations.find(params[:id])
    @mutation.destroy
    flash[:notice] = "Successfully destroyed mutation."
    redirect_to mutations_url
  end

protected

  def get_evolution_from_mutation
    mutation = Mutation.find(params[:id])
    @evolution = Evolution.find(mutation.evolution_id)
  end
end
