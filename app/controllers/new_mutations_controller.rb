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
  def go_new # new_mutation_or_child_mutation
    if new_mutation_is_child?
      if mutation_is_root? Mutation.find(params[:mutation_id])
	get_evolution_with_id_of_evolution mutation.evolution_id
      else # mutation is not root
	get_root_mutation_with_mutation mutation
	get_evolution_with_id_of_evolution @root_mutation.evolution_id
      end
      get_new_mutation
      set_mutation_parent_id_to_this params[:mutation_id]
    else # then new mutation is NOT a child
      get_evolution_with_id_of_evolution params[:evolution_id]
      get_new_mutation_through_evolution
      set_mutation_evolution_id_to_this params[:evolution_id]
    end
  end
  def go_create
    #...
  end
  def go_update
  end
  def go_destroy
  end


  def go_new_root
  end
  def go_new_parent
  end
  def go_new_current
  end
  def go_new_child
    #...
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
    if mutation_is_root?
      get_evolution_with_id_of_evolution mutation.evolution_id
      get_mutation_through_evolution_with_id_of_mutation params[:id]
    else
      root_mutation = mutation.ancestors.last # get root mutation
      get_evolution_with_id_of_evolution root_mutation.evolution_id
      get_mutation_with_id_of_mutation params[:id]
    end
  end

  def mutation_is_root?(pass_mutation)
    pass_mutation.evolution_id # if root then true
  end

  def get_root_mutation_with_mutation(pass_mutation)
    @root_mutation = pass_mutation.ancestors.last
  end

  def set_mutation_parent_id_to_this(id_of_parent_mutation)
    @mutation.mutation_id = id_of_parent_mutation
  end
  def set_mutation_evolution_id_to_this(id_of_evolution)
    @mutation.evolution_id = id_of_evolution
  end
  
  def new_mutation_is_child?
    if params[:mutation_id]
      true
    else
      false
    end
  end
end
