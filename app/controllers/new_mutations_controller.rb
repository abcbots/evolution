class MutationsController < ApplicationController

# new | clone | move | destroy
# current | current_only
# root | parent | current | child
# new: root | parent | current | child

# clone: current | current_only
# clone_current_to: root | parent | current | child
# clone_current_only_to: root | parent | current | child

# move: current | current_only
# move_current_to: root | parent | current | child
# move_current_only_to: root | parent | current | child

# destroy: current | current_only

  def index
    go_index
  end
  def show
    go_show
  end
  def new
    go_new
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

  def new_root
    go_new_root
    # in_process
  end
  def new_parent
    go_new_parent
  end
  def new_current
    go_new_current
  end
  def new_child
    go_new_child
  end

  def clone_current_set
    go_clone_current_set
  end

  def clone_current_to_root
    go_clone_current_to_root
  end
  def clone_current_to_parent
    go_clone_current_to_parent
  end
  def clone_current_to_current
    go_clont_current_to_current
  end
  def clone_current_to_child
    go_clone_current_to_child
  end

  def clone_current_only_set
    go_clone_current_only_set
  end

  def clone_current_only_to_root
    go_clone_current_only_to_root
  end
  def clone_current_only_to_parent
    go_clone_current_only_to_parent
  end
  def clone_current_only_to_current
    go_clone_current_only_to_current
  end
  def clone_current_only_to_child
    go_clone_current_only_to_child
  end

  def move_current_set
    go_move_current_set
  end

  def move_current_to_root
    go_move_current_to_root
  end
  def move_current_to_parent
    go_move_current_to_parent
  end
  def move_current_to_current
    go_move_current_to_current
  end
  def move_current_to_child
    go_move_current_to_child
  end

  def move_current_only_set
    go_move_current_only_set
  end

  def move_current_only_to_root
    go_move_current_only_to_root
  end
  def move_current_only_to_parent
    go_move_current_only_to_parent
  end
  def move_current_only_to_current
    go_move_current_only_to_current
  end
  def move_current_only_to_child
    go_move_current_only_to_child
  end

  def destroy_current
    go_destroy_current
  end
  def destroy_current_only
    go_destroy_current_only
  end

#protected

  def go_index
    get_evolution_with_id_of_evolution params[:evolution_id]
    get_mutations_through_evolution
  end
  def go_show
    get_mutation_and_evolution_with_id_of_mutation
  end
  def go_new # new_mutation_or_new_child_mutation
    if is_new_mutation_a_child?
      if is_mutation_a_root? Mutation.find(params[:mutation_id])
	get_evolution_with_id_of_evolution mutation.evolution_id
      else # mutation is NOT root
	get_root_mutation_with_mutation mutation
	get_evolution_with_id_of_evolution @root_mutation.evolution_id
      end
      get_new_mutation
      set_mutation_parent_id params[:mutation_id]
    else # then new mutation is NOT a child
      get_evolution_with_id_of_evolution params[:evolution_id]
      get_new_mutation_through_evolution
      set_mutation_evolution_id params[:evolution_id]
    end
  end
  def go_create
    get_new_mutation_from_form_submission
    if @mutation.save
      flash[:notice] = "Creation Success"
      redirect_to @mutation
    else
      render :action => 'new'
    end
  end
  def go_update
    get_mutation_and_evolution_with_id_of_mutation
    if update_attributes_for_mutation
      flash[:notice] = "Update Success, Thank You"
      redirect_to @mutation
    else
      flash[:notice] = "Update Fail, Try Again"
      redirect_to @mutation
    end
  end
  def go_destroy
    get_mutation_and_evolution_with_id_of_mutation
    mutation_parent = mutation.ancestors.first # get mutation parent
    @mutation.destroy # destroy mutation
    if mutation_parent # if mutation parent exists
      flash[:notice] = "Destruction Success" # flash success
      redirect_to mutation_parent # redirect to parent
    else # then mutation evolution exists
      flash[:notice] = "Destruction Success" # flash success
      redirect_to evolution_mutations_path(:evolution_id => @evolution.id) # goto index
    end
  end


  def go_new_root
    # in_process
  end
  def go_new_parent
    mutation_current = Mutation.find(params[:id]) # get current
    if mutation_current.mutation_id # if has parent?
      mutation_parent = Mutation.find(mutation_current.mutation.id # get parent
      mutation_current.mutation_id = nil # detach parent from current
      get_new_mutation # get new 
      @mutation.mutation_id = mutation_parent.id # attach new to parent
      if @mutation.save # save new
        status = "Success Creating New Parent"
      else
        status = "Failure Creating New Parent"
      end
      mutation_current.mutation_id = @mutation.id # attach current to new
      mutation_current.save # save current
    else # else has super_parent
      if mutation_current.evolution_id # if is root?
        mutation_super_parent = Evolution.find(mutation_current.evolution_id) # get super_parent
	mutation_current.evolution_id = nil # detach current from super_parent
        @mutation = Mutation.new # get new 
        @mutation.evolution_id = mutation_super_parent.id # attach new to super_parent
        if @mutation.save # save new
          status = "Success Creating New Parent"
        else
          status = "Failure Creating New Parent"
        end
        mutation_current.mutation_id = @mutation.id # attach current to new
        mutation_current.save # save current
      end
    end
    flash[:notice] = status # flash status
    redirect_to @mutation # redirect to new
  end
  def go_new_current
    mutation = Mutation.find(params[:id]) # get mutation
      if mutation.evolution_id # if mutation root
	get_evolution_with_id_of_evolution mutation.evolution_id
	get_new_mutation_through_evolution
      else # then mutation non_root
        get_new_mutation
	set_mutation_parent_id mutation.id 
      end 
    save_mutation
    flash[:notice] = "New Mutation Root Success, Thank You"
    redirect_to @mutation
  end
  def go_new_child
    get_new_mutation
    set_mutation_parent_id params[:id]
    save_mutation
    flash[:notice] = "New Mutation Child Success, Thank You"
    redirect_to @mutation
  end




      mutation = Mutation.find(params[:mutation_id])
    
    else
      @evolution = Evolution.find(params[:evolution_id])
      @mutation = @evolution.mutations.new
      @mutation.evolution_id = params[:evolution_id]
    end

  end

  def go_clone_current_set
  end

  def go_clone_current_to_root
  end
  def go_clone_current_to_parent
  end
  def go_clone_current_to_current
  end
  def go_clone_current_to_child
  end

  def go_clone_current_only_set
  end

  def go_clone_current_only_to_root
  end
  def go_clone_current_only_to_parent
  end
  def go_clone_current_only_to_current
  end
  def go_clone_current_only_to_child
  end

  def go_move_current_set
  end

  def go_move_current_to_root
  end
  def go_move_current_to_parent
  end
  def go_move_current_to_current
  end
  def go_move_current_to_child
  end

  def go_move_current_only_set
  end

  def go_move_current_only_to_root
  end
  def go_move_current_only_to_parent
  end
  def go_move_current_only_to_current
  end
  def go_move_current_only_to_child
  end

  def go_destroy_current
  end
  def go_destroy_current_only
  end

  # new

  def get_new_mutation
    @mutation = Mutation.new
  end
  def get_new_mutation_through_evolution
    @mutation = @evolution.mutations.new
  end
  def get_new_mutation_from_form_submission(mutation_params=params[:mutation])
    @mutation = Mutation.new(mutation_params)
  end
  
  def get_mutation_with_id_of_mutation(id_of_mutation)
    @mutation = Mutation.find(id_of_mutation) # get mutation
  end
  def get_evolution_with_id_of_evolution(id_of_evolution)
    @evolution = Evolution.find(id_of_evolution)
  end
  def get_mutations_through_evolution
    @mutations = @evolution.mutations.all
  end
  def get_mutation_through_evolution_with_id_of_mutation(id_of_mutation)
    @mutation = @evolution.mutations.find(id_of_mutation) # get mutation
  end
  def get_mutation_and_evolution_with_id_of_mutation
    mutation = Mutation.find(params[:id])
    if is_mutation_a_root?
      get_evolution_with_id_of_evolution mutation.evolution_id
      get_mutation_through_evolution_with_id_of_mutation params[:id]
    else
      root_mutation = mutation.ancestors.last # get root mutation
      get_evolution_with_id_of_evolution root_mutation.evolution_id
      get_mutation_with_id_of_mutation params[:id]
    end
  end
  def get_mutation_parent_with_id_of_mutation(id_of_mutation)
    mutation = Mutation.find(id_of_mutation)
    @mutation_parent = mutation.ancestors.first
  end

  def update_attributes_for_mutation
    @mutation.update_attributes(params[:mutation])
  end

  def is_mutation_a_root?(pass_mutation)
    if pass_mutation.evolution_id # if root then true
      true
    else
      false
    end
  end

  def get_root_mutation_with_mutation(mutation)
    @root_mutation = mutation.ancestors.last
  end

  def set_mutation_parent_id(id_of_parent_mutation)
    @mutation.mutation_id = id_of_parent_mutation
  end
  def set_mutation_evolution_id(id_of_evolution)
    @mutation.evolution_id = id_of_evolution
  end
  
  def is_new_mutation_a_child?
    if params[:mutation_id]
      true
    else
      false
    end
  end

  def save_mutation
    @mutation.save
  end
  
end
