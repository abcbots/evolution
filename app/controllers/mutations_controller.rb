class MutationsController < ApplicationController
include MutationsHelper
  def index
    evolution_id_to_all_mutations_of_current_evolution
    @title = "Index"
  end
  def show
    id_to_evolution_mutation
    @title = "Mutation(#{@mutation.id})"
  end
  def move_current 
    id_to_mutation_and_tag_for_move
  end
  def cancel_move
    id_to_mutation_and_save_to_session
  end
  def complete
    id_to_set_completed_at_of_mutation
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
  def clone_current
  end
  def clone_current_and_before
    id_to_clone_current_and_before
    redirect_to @mutation
  end
  def create
    mutation_params_to_saved_mutation
  end
  def update
    id_to_evolution_mutation_and_update
  end
  def destroy
    id_to_evolution_mutation_and_destroy
  end
  def destroy_current_only
    id_to_evolution_mutation_and_detatch_and_destroy
  end

protected

    # local mutation equals mutation from id
    # if mutation has the evolution id
      # evolution equals evolution from evolution id
      # mutation equals mutation from id through evolution
      # title equals mutation id
      # mutation rooting equals the first mutation on tree
      # evolution equals evolution from first mutation on tree
      # mutation equals passed mutation id
      # title equals prior mutation(mutation id)
  def id_to_evolution_mutation
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

  # make new mutation or child mutation based on params
    # turn off links
    # if passed mutation_id
      # mutation equals mutation from mutation_id passed
      # if mutation has the evolution_id
	# then evolution equals evolution from passed evolution_id
	# and mutation equals a new mutation
	# and mutation-mutation_id equals mutation id passed
	# mutation equals the head mutation of the tree
	# evolution equals the evolution found from passed evolution_id
	# mutation equals new mutation
	# mutation---mutation_id equals passed mutation_id
    # else, mutation must be head of branch, so...
      # evolution equals evolution from passed evolution id
      # mutation equals new mutation through evolution
      # evolution_id from mutation, equals passed evolution_id
  def new_mutation_or_child_mutation
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

  def evolution_id_to_all_mutations_of_current_evolution
    # evolution equals evolution from passed evolution_id
    @evolution = Evolution.find(params[:evolution_id])
    # mutation equals all mutations of evolution
    @mutations = @evolution.mutations.all
  end

  def id_to_set_completed_at_of_mutation
    id_to_evolution_mutation
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

  def id_to_mutation_and_tag_for_move
    id_to_mutation
    # set session current mutation to current mutation
    session[:move_mutation_id] = @mutation.id
    # goto current mutation
    redirect_to @mutation
  end

  def id_to_mutation
    @mutation = Mutation.find(params[:id])
  end

  def id_to_evolution_mutation_and_update
    id_to_evolution_mutation
    # for id mutation equals evolution mutation
    @mutation = @evolution.mutations.find(params[:id])
    if @mutation.update_attributes(params[:mutation])
      flash[:notice] = "Successfully updated mutation."
      redirect_to @mutation
    else
      render :action => 'edit'
    end
  end

  def id_to_evolution_mutation_and_destroy
    id_to_evolution_mutation
    @mutation = @evolution.mutations.find(params[:id])
    @mutation.destroy
    flash[:notice] = "Successfully destroyed mutation."
    redirect_to evolution_mutations_path(@evolution)
  end

  def id_to_mutation_and_save_to_session
    id_to_mutation
    # set session move current id to nil
    session[:move_mutation_id] = nil
    # redirect to mutation
    redirect_to @mutation
  end

  def id_to_evolution_mutation_and_detatch_and_destroy
    id_to_evolution_mutation
    if_mutation_root_or_child_then_transfer_evolution_or_parent_to_children
    @mutation.evolution_id = nil
    @mutation.mutation_id = nil
    @mutation.save
    redirect_to :action => 'index', :evolution_id => @evolution
  end
  def if_mutation_root_or_child_then_transfer_evolution_or_parent_to_children
    if @mutation.mutation_id
      for mutation in @mutation.children
        mutation.mutation_id = @mutation.mutation_id
	mutation.save
      end
    else
      for mutation in @mutation.children
        mutation.evolution_id = @mutation.evolution_id
	mutation.mutation_id = nil
	mutation.save
      end
    end
  end

  def id_to_clone_current_and_before
    id_to_evolution_mutation
    mutation_clone = Mutation.new
    #for testing purposes
    mutation_clone.evolution_id = @evolution.id
    #mutation_clone.information = mutation.information
    mutation_clone.save
    clone_mutation_children @mutation, mutation_clone
  end
  def clone_mutation_children(mutation, parent)
    for mutation in mutation.children
      mutation_clone = Mutation.new
      mutation_clone.mutation_id = parent.id
      #mutation_clone.information = mutation.information
      mutation_clone.save
      clone_mutation_children_even mutation, mutation_clone
    end
  end
  def clone_mutation_children_even(mutation, parent)
    for mutation in mutation.children
      mutation_clone = Mutation.new
      mutation_clone.mutation_id = parent.id
      #mutation_clone.information = mutation.information
      mutation_clone.save
      clone_mutation_children mutation, mutation_clone
    end
  end
    
end

