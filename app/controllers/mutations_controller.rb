class MutationsController < ApplicationController
include MutationsHelper
  def index
    evolution_id_to_all_mutations_of_current_evolution
    @title = "Index"
  end
  def show
    id_to_evolution_mutation
    @title = "Evolution(#{@evolution.id}) > Mutation(#{@mutation.id})"
  end
  def new
    make_new_mutation_or_new_past_child_mutation
  end
  def new_after
    make_new_mutation_after_current_mutation
  end
  def new_current
    make_new_current_level_mutation
  end
  def clone_current_set
    go_clone_current_set
  end
  def clone_current_cancel
    go_clone_current_cancel
  end
  def clone_current_to_root
  end
  def clone_current_to_past
  end
  def clone_current_to_current
  end
  def clone_current_to_future
  end
  def clone_current_and_past_set
    go_clone_current_and_past_set
  end
  def clone_current_and_past_cancel
    go_clone_current_and_past_cancel
  end
  def clone_current_and_past_to_root
    go_clone_current_and_past_to_root 
  end
  def clone_current_and_past_to_past
    go_clone_current_and_past_to_past
  end
  def clone_current_and_past_to_current
  end
  def clone_current_and_past_to_future
  end
  def move_current_set
    go_move_current_set
  end
  def move_current_cancel
    go_move_current_cancel
  end
  def move_current 
    go_move_current
  end
  def move_current_and_past
  end
  def complete
    go_complete
  end
  def create
    go_create
  end
  def update
    go_update
  end
  def destroy
    go_destroy
  end
  def destroy_current
    go_destroy_current
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

  def go_complete
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

  def make_new_mutation_or_new_past_child_mutation
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

  def go_create
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

  def id_to_mutation
    @mutation = Mutation.find(params[:id])
  end

  def go_update
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

  def go_move_current_set
    id_to_evolution_mutation # id to mutation and evolution
    session[:mutation_to_move_current] = @mutation.id # set mutation to clone id
    redirect_to @mutation # go back to mutation
  end

  def go_move_current_cancel
    id_to_mutation
    # set session move current id to nil
    session[:move_mutation_id] = nil
    # redirect to mutation
    redirect_to @mutation
  end

  def go_move_current
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

  def go_clone_current_set
    id_to_evolution_mutation
    session[:mutation_to_clone_current] = @mutation.id
    redirect_to mutation_path(session[:mutation_to_clone_current])
  end
  def go_clone_current_and_past_set
    id_to_evolution_mutation
    session[:mutation_to_clone_current_and_past] = @mutation.id
    redirect_to mutation_path(session[:mutation_to_clone_current_and_past])
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

  def go_clone_current_cancel
    id_to_evolution_mutation
    session[:mutation_to_clone_current] = nil
    redirect_to @mutation 
  end
  
  def go_clone_current_and_past_cancel
    id_to_evolution_mutation
    session[:mutation_to_clone_current_and_past] = nil
    redirect_to @mutation 
  end
    
  def go_clone_current_and_past_to_root 
    mutation_starter = Mutation.find(session[:mutation_to_clone_current_and_past]) # mutation to clone from
    mutation_new = Mutation.new # make new mutation
    mutation_new.evolution_id = params[:id] # copy evolution
    mutation_new.save # save
    clone_mutation_children mutation_starter, mutation_new # clone children
    redirect_to mutation_path(mutation_new) # redirect to mutation new
  end
 
  def go_clone_current_and_past_to_past
    mutation_starter = Mutation.find(session[:mutation_to_clone_current_and_past]) # mutation to clone from
    mutation_new = Mutation.new # make new mutation
    mutation_new.save # save
    clone_mutation_children mutation_starter, mutation_new # clone children
    mutation_loaded = mutation_new
    mutation_loaded.mutation_id = params[:id] # copy parent id from params
    mutation_loaded.save # save
    redirect_to mutation_path(mutation_loaded) # redirect to loaded mutation
  end

  def mutation_new_mutation_id_to_params_id
  end

  def go_destroy
    id_to_evolution_mutation
    @mutation = @evolution.mutations.find(params[:id])
    @mutation.destroy
    flash[:notice] = "Successfully destroyed mutation."
    redirect_to evolution_mutations_path(@evolution)
  end

  def go_destroy_current
    id_to_evolution_mutation
    if_mutation_root_or_child_then_transfer_evolution_or_parent_to_children
    @mutation.evolution_id = nil
    @mutation.mutation_id = nil
    @mutation.save
    redirect_to :action => 'index', :evolution_id => @evolution
  end
     
end

