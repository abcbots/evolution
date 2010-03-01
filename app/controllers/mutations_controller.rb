class MutationsController < ApplicationController
  def index
    @title = "Index"
    evolution_id_to_all_mutations_of_current_evolution
  end
  
  def show
    mutation_id_to_mutation_and_evolution
    @title = "Mutation(#{@mutation.id})"
  end

  def complete
    mutation_id_to_set_completed_at_of_mutation
  end
  
  def new
    make_new_mutation_or_new_before_child_mutation
  end

  def new_after
    make_new_mutation_after_current_mutation
  end

  def new_current
    make_new_current_level_mutation
  end

  def create
    mutation_params_to_saved_mutation
  end
  
  def update
    mutation_id_to_mutation_and_evolution
    # for id mutation equals evolution mutation
    @mutation = @evolution.mutations.find(params[:id])
    if @mutation.update_attributes(params[:mutation])
      flash[:notice] = "Successfully updated mutation."
      redirect_to @mutation
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    mutation_id_to_mutation_and_evolution
    @mutation = @evolution.mutations.find(params[:id])
    @mutation.destroy
    flash[:notice] = "Successfully destroyed mutation."
    redirect_to evolution_mutations_path(@evolution)
  end

protected

  def mutation_id_to_mutation_and_evolution
    # local mutation equals mutation from id
    mutation = Mutation.find(params[:id])
    # if mutation has the evolution id
    if mutation.evolution_id
      # evolution equals evolution from evolution id
      @evolution = Evolution.find(mutation.evolution_id)
      # mutation equals mutation from id through evolution
      @mutation = @evolution.mutations.find(params[:id])
      # title equals mutation id
      @title = "Mutation #{@mutation.id}"
    else
      # mutation rooting equals the first mutation on tree
      mutation_rooting = mutation.ancestors.last
      # evolution equals evolution from first mutation on tree
      @evolution = Evolution.find(mutation_rooting.evolution_id)
      # mutation equals passed mutation id
      @mutation = Mutation.find(params[:id])
      # title equals prior mutation(mutation id)
      @title = "Prior Mutation #{@mutation.id}"
    end
  end

  # make new mutation or child mutation based on params
  def new_mutation_or_child_mutation
    # turn off links
    @no_links = true
    # if passed mutation_id
    if params[:mutation_id]
      # mutation equals mutation from mutation_id passed
      mutation = Mutation.find(params[:mutation_id])
      # if mutation has the evolution_id
      if mutation.evolution_id
	# then evolution equals evolution from passed evolution_id
        @evolution = Evolution.find(mutation.evolution_id)
	# and mutation equals a new mutation
        @mutation = Mutation.new
	# and mutation-mutation_id equals mutation id passed
        @mutation.mutation_id = params[:mutation_id]
      else
	# mutation equals the head mutation of the tree
        mutation = mutation.ancestors.last
	# evolution equals the evolution found from passed evolution_id
        @evolution = Evolution.find(mutation.evolution_id)
	# mutation equals new mutation
        @mutation = Mutation.new
	# mutation---mutation_id equals passed mutation_id
        @mutation.mutation_id = params[:mutation_id]
      end
    # else, mutation must be head of branch, so...
    else
      # evolution equals evolution from passed evolution id
      @evolution = Evolution.find(params[:evolution_id])
      # mutation equals new mutation through evolution
      @mutation = @evolution.mutations.new
      # evolution_id from mutation, equals passed evolution_id
      @mutation.evolution_id = params[:evolution_id]
    end
  end

  def evolution_id_to_all_mutations_of_current_evolution
    # evolution equals evolution from passed evolution_id
    @evolution = Evolution.find(params[:evolution_id])
    # mutation equals all mutations of evolution
    @mutations = @evolution.mutations.all
  end

  def mutation_id_to_set_completed_at_of_mutation
    mutation_id_to_mutation_and_evolution
    mutation_completed_at_equals_time_current
    if_mutation_saves_then_flash_confirm_and_goto_index
  end

  def mutation_completed_at_equals_time_current
    # completed_at of mutation equals the time current
    @mutation.completed_at = Time.current
  end

  def if_mutation_saves_then_flash_confirm_and_goto_index
    # can mutation save? if yes
    if @mutation.save
      # then flash success confirmation with mutation id and completed_at
      flash[:notice] = "Successfully completed mutation(#{@mutation.id}) at #{@mutation.completed_at}"
      # then goto agenda controller, index page
      redirect_to :controller => 'agenda', :action => 'index'
    # or else, it most likely failed
    else
      # so then flash error
      flash[:error] = "Sorry, try again."
      # then goto mutation show page
      redirect_to @mutation
    end
  end

  def make_new_mutation_or_new_before_child_mutation
    new_mutation_or_child_mutation
    # save the mutation
    @mutation.save
    # goto mutation show page
    redirect_to @mutation
  end

  def make_new_mutation_after_current_mutation
    # turn off links
    @no_links = true
    # current_mutation equals mutation from passed id
    current_mutation = Mutation.find(params[:id])
    # mutation equals new mutation
    @mutation = Mutation.new
    # evolution_id of mutation equals evolution_id of current_mutation
    @mutation.evolution_id = current_mutation.evolution_id
    # mutation_id of mutation equals current_mutation
    @mutation.mutation_id = current_mutation.mutation_id
    # evolution_id of current_mutation equals nothing
    current_mutation.evolution_id = nil
    # save mutation
    @mutation.save
    # mutation_id of current_mutation equals id of mutation
    current_mutation.mutation_id = @mutation.id
    # save current_mutation
    current_mutation.save
    # goto mutation show page
    redirect_to @mutation
  end

  def make_new_current_level_mutation
    # turn links off
    @no_links = true
    # current_mutation equals mutation from passed id
    current_mutation = Mutation.find(params[:id])
    # mutation equals new mutation
    @mutation = Mutation.new
    # if exists? mutation_after equals mutation from mutation_id of current_mutation
    if mutation_after = Mutation.find(current_mutation.mutation_id)
      # mutation_id of mutation equals id of mutation_after
      @mutation.mutation_id = mutation_after.id
    # or else, if mutation is not a parent, then it must be a root! 
    else
      # so, evolution_id equals evolution_id of current_mutation
      @mutation.evolution_id = current_mutation.evolution_id
    end
    # save mutation
    @mutation.save
    # goto mutation show action
    redirect_to @mutation
  end

  def mutation_params_to_saved_mutation
    # mutation equals mew mutation with mutation params
    @mutation = Mutation.new(params[:mutation])
    # if mutation saves then flash success and goto mutation show
    if @mutation.save
      flash[:notice] = "Successfully created mutation."
      redirect_to @mutation
    else
      render :action => 'new'
    end
  end

end

