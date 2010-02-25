class MutationsController < ApplicationController
  def index
    @evolution = Evolution.find(params[:evolution_id])
    @mutations = @evolution.mutations.all
  end
  
  def show
    beautify_mutation
  end
  
  def new
    newify_mutation
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
    beautify_mutation
    @mutation = @evolution.mutations.find(params[:id])
  end
  
  def update
    beautify_mutation
    @mutation = @evolution.mutations.find(params[:id])
    if @mutation.update_attributes(params[:mutation])
      flash[:notice] = "Successfully updated mutation."
      redirect_to @mutation
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    beautify_mutation
    @mutation = @evolution.mutations.find(params[:id])
    @mutation.destroy
    flash[:notice] = "Successfully destroyed mutation."
    redirect_to evolution_mutations_path(@evolution)
  end

protected

  def beautify_mutation
    mutation = Mutation.find(params[:id])
    if mutation.evolution_id
      @evolution = Evolution.find(mutation.evolution_id)
      @mutation = @evolution.mutations.find(params[:id])
      @title = "Mutation #{@mutation.id}"
    else
      mutation_rooting = mutation.ancestors.last
      @evolution = Evolution.find(mutation_rooting.evolution_id)
      @mutation = Mutation.find(params[:id])
      @title = "Prior Mutation #{@mutation.id}"
    end
  end

  def newify_mutation
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

end
