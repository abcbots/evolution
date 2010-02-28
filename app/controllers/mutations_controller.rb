class MutationsController < ApplicationController
  def index
    @evolution = Evolution.find(params[:evolution_id])
    @mutations = @evolution.mutations.all
  end
  
  def show
    beautify_mutation
  end

  def complete
    beautify_mutation
    @mutation.completed_at = Time.now
    if @mutation.save
      flash[:notice] = "Successfully completed mutation(#{@mutation.id}) at #{@mutation.completed_at}"
      redirect_to :controller => 'agenda', :action => 'index'
    else
      flash[:error] = "Sorry, try again."
      redirect_to @mutation
    end
  end
  
  def new
    newify_mutation
    @mutation.save
    redirect_to @mutation
  end

  def new_after
    @no_links = true
    # new parent mutation, trade parent and super parent for id
    mutation_now = Mutation.find(params[:id])
    @mutation = Mutation.new
    @mutation.evolution_id = mutation_now.evolution_id
    @mutation.mutation_id = mutation_now.mutation_id
    mutation_now.evolution_id = nil
    @mutation.save
    mutation_now.mutation_id = @mutation.id
    mutation_now.save
    redirect_to @mutation
  end

  def new_now
    @no_links = true
    # get current mutation
    @mutation_now = Mutation.find(params[:id])
    # create new mutation
    @mutation = Mutation.new
    # if there is a mutation after then get it
    if @mutation_now.mutation_id
      # mutation parent is mutation now's parent
      @mutation_after = Mutation.find(@mutation_now.mutation_id)
      # mutation parent is mutation after
      @mutation.mutation_id = @mutation_after.id
    # or if there is not a mutation after
    else
      if @mutation_now.evolution_id
        # mutation super parent is mutation now's super parent
        @mutation.evolution_id = @mutation_now.evolution_id
      end
    end
    @mutation.save
    redirect_to @mutation
    # test with parent
    # test with evolution
    # test with neither...
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
    # get current mutation
    mutation_now = @evolution.mutations.find(params[:id])
    # get child mutation(s)
    mutation_befores = mutation_now.children.all
    # if mutation has parent then connect parent to child
    if mutation_after = Mutation.find(mutation_now.mutation_id)
      # connect parent to child
      mutation_befores.each do |mutation_before|
        mutation_before.mutation_id = mutation_after.id
        mutation_before.save
      end
    # else if mutation has no parent then connect evolution to child
    else
      # connect evolution to child
      mutation_befores.each do |mutation_before|
        mutation_before.evolution_id = @evolution.id
	mutation_before.mutation_id = nil
        mutation_before.save
      end
    end
    mutation_now.destroy
    # if there is a mutation parent, redirect to parent
    if @mutation = mutation_after
      # flash confirmation
      flash[:notice] = "Successfully destroyed mutation(#{mutation_now.id}); now redirecting to parent mutation(#{mutation_after.id})"
      # redirect to parent mutation
      redirect_to mutation_path(mutation_after)
    # else, if no parent, redirect to closest evolution
    else
      # flash confirmation
      flash[:notice] = "Successfully destroyed mutation(#{mutation_now.id}); now redirecting to evolution of mutation(#{mutation_after.id})"
      # redirect to parent mutation
      redirect_to mutation_path(@evolution)
    end
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
