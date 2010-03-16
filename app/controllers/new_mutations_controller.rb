class MutationsController < ApplicationController

# new | clone | move | destroy
# current | current_partial
# root | parent | current | child
# new: root | parent | current | child

# clone: current | current_partial
# move: current | current_partial

# clone_current_to: root | parent | current | child | cancel
# clone_current_partial_to: root | parent | current | child | cancel

# move_current_to: root | parent | current | child | cancel
# move_current_partial_to: root | parent | current | child | cancel

# destroy: current | current_partial

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

  def set_clone_current
    go_set_clone_current
  end
  def set_clone_current_partial
    go_set_clone_current_partial
  end
  def set_move_current
    go_set_move_current
  end
  def set_move_current_partial
    go_set_move_current_partial
  end

  def cancel_clone_current
    go_cancel_clone_current
  end
  def cancel_clone_current_partial
    go_cancel_clone_current_partial
  end
  def cancel_move_current
    go_cancel_move_current
  end
  def cancel_move_current_partial
    go_cancel_move_current_partial
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

  def clone_current_partial_to_root
    go_clone_current_partial_to_root
  end
  def clone_current_partial_to_parent
    go_clone_current_partial_to_parent
  end
  def clone_current_partial_to_current
    go_clone_current_partial_to_current
  end
  def clone_current_partial_to_child
    go_clone_current_partial_to_child
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

  def move_current_partial_to_root
    go_move_current_partial_to_root
  end
  def move_current_partial_to_parent
    go_move_current_partial_to_parent
  end
  def move_current_partial_to_current
    go_move_current_partial_to_current
  end
  def move_current_partial_to_child
    go_move_current_partial_to_child
  end

  def destroy_current
    go_destroy_current
  end
  def destroy_current_partial
    go_destroy_current_partial
  end

#protected

  def save_move_current
    if @mutation_move_current.save # save move_current
      flash_success # success
      session[:mutation_move_current_id] = nil # clear move
      redirect_to @mutation_move_current # redirect to current
    else # else
      flash_fail # fail
      redirect_to @mutation_current # redirect to current
    end
  end
  
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


  def go_new_root
    mutation_current = Mutation.find(params[:id]) # get current
    mutation_super = Evolution.find(mutation_current.evolution_id) # get super
    mutation_root = mutation_current.ancestors.last # get root
    mutation_new = Mutation.new # get new
    mutation_new.evolution_id = mutation_super.id # attach new to super
    mutation_new.save # save new
    mutation_root.evolution_id = nil # detach root from super
    mutation_root.mutation_id = mutation_new.id # attach root to new
    mutation_root.save # save root
    flash[:notice] "Success, New Root Complete" # flash success, new root planted
    redirect_to mutation_new # redirect to new
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
    save_mutation @mutation
  end
  def go_new_child
    get_new_mutation
    set_mutation_parent_id params[:id]
    save_mutation @mutation
    flash[:notice] = "New Mutation Child Success, Thank You"
    redirect_to @mutation
  end

  def go_set_clone_current
    mutation_current = Mutation.find(params[:id]) # get current
    session[:clone_current_id] = mutation_current.id # set clone current
    redirect_to @mutation # redirect to current
  end
  def go_set_clone_current_partial
    mutation_current = Mutation.find(params[:id]) # get current
    session[:clone_current_partial_id] = mutation_current.id # set clone current
    redirect_to mutation_current # redirect to current
  end
  def go_set_move_current
    mutation_current = Mutation.find(params[:id]) # get current
    session[:mutation_move_current_id] = mutation_current.id # set move current
    redirect_to mutation_current # redirect to current
  end
  def go_set_move_current_partial
    mutation_current = Mutation.find(params[:id]) # get current
    session[:move_current_partial_id] = mutation_current.id # set move current only
    redirect_to mutation_current # redirect to current
  end

  def go_cancel_clone_current
    session[:clone_current_id] = nil # cancel clone current
  end
  def go_cancel_clone_current_partial
    session[:clone_current_partial_id] = nil # cancel clone current
  end
  def go_cancel_move_current
    session[:mutation_move_current_id] = nil # cancel move current
  end
  def go_cancel_move_current_partial
    session[:move_current_partial_id] = nil # cancel move current only
  end

  def go_clone_mutation_to_mutation(subject, target, whole=true)
    get_mutations
    get_mutation_clone subject, whole
    attach_mutation_to_mutation subject, target
    save_mutation subject
  end
  def get_mutation_clone(subject, whole=true)
    object_to_clone = Mutation.find(@set session[:set_mutation_clone_current]) # get object to clone
    @mutation_clone = Mutation.new # create new clone
    # copy current info to clone
    @mutation_clone.save # save clone
    if whole # if whole is true
      then_go_clone_children object_to_clone, @mutation_clone # clone children of current, to new parent
    end
  end

  def go_clone_current_to_root
    get_mutation_clone_current # then get mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current
    mutation_root = mutation_current.ancestors.last # get root
    @mutation_clone.evolution_id = mutation_root.evolution_id # attach clone to root super
    @mutation_clone.save # save clone
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_to_parent
    get_mutation_clone_current # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    if mutation_current.mutation_id # if mutation parent present then
      @mutation_clone.mutation_id = mutation_current.mutation_id # attach clone to parent
      @mutation_clone.save # save clone
      mutation_current.mutation_id = @mutation_clone.id # attach current to clone
      mutation_current.save # save current
    else # else
      if mutation_current.evolution_id # if mutation super present then
        @mutation_clone.evolution_id = mutation_current.evolution_id # attach clone to super
        @mutation_clone.save # save clone
        mutation_current.evolution_id = @mutation_clone.id # attach current to clone
        mutation_current.save # save current
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_to_current
    get_mutation_clone_current # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    if mutation_current.mutation_id # if mutation parent present then
      @mutation_clone.mutation_id = mutation_current.mutation_id # attach clone to parent
      @mutation_clone.save # save clone
    else # else
      if mutation_current.evolution_id # if mutation super present then
        @mutation_clone.evolution_id = mutation_current.evolution_id # attach clone to super
        @mutation_clone.save # save clone
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_to_child
    get_mutation_clone_current # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    @mutation_clone.mutation_id = mutation_current.id # attach clone to current 
    @mutation_clone.save # save clone
    if mutation_current.children.exists? # if current has children
      for mutation in mutation_current.children # attach children to clone
        mutation.mutation_id = @mutation_clone.id # attach child to clone
        mutation.save # save child
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end

# **************************************************************************************************

  def go_clone_current_partial_to_root
    get_mutation_clone_current_partial # get mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current
    mutation_root = mutation_current.ancestors.last # get root
    @mutation_clone.evolution_id = mutation_root.evolution_id # attach clone to root super
    @mutation_clone.save # save clone
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_partial_to_parent
    get_mutation_clone_current_partial # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    if mutation_current.mutation_id # if mutation parent present then
      @mutation_clone.mutation_id = mutation_current.mutation_id # attach clone to parent
      @mutation_clone.save # save clone
      mutation_current.mutation_id = @mutation_clone.id # attach current to clone
      mutation_current.save # save current
    else # else
      if mutation_current.evolution_id # if mutation super present then
        @mutation_clone.evolution_id = mutation_current.evolution_id # attach clone to super
        @mutation_clone.save # save clone
        mutation_current.evolution_id = @mutation_clone.id # attach current to clone
        mutation_current.save # save current
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_partial_to_current
    get_mutation_clone_current_partial # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    if mutation_current.mutation_id # if mutation parent present then
      @mutation_clone.mutation_id = mutation_current.mutation_id # attach clone to parent
      @mutation_clone.save # save clone
    else # else
      if mutation_current.evolution_id # if mutation super present then
        @mutation_clone.evolution_id = mutation_current.evolution_id # attach clone to super
        @mutation_clone.save # save clone
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end
  def go_clone_current_partial_to_child
    get_mutation_clone_current_partial # generate @mutation_clone
    mutation_current = Mutation.find(params[:id]) # get current from passed id
    @mutation_clone.mutation_id = mutation_current.id # attach clone to current 
    @mutation_clone.save # save clone
    if mutation_current.children.exists? # if current has children
      for mutation in mutation_current.children # attach children to clone
        mutation.mutation_id = @mutation_clone.id # attach child to clone
        mutation.save # save child
      end # end
    end # end
    redirect_to @mutation_clone # redirect to clone
  end

# **************************************************************************************************

  def go_move_current_to_root
    get_mutations # get mutations
    @mutation_move_current.evolution_id = @mutation_root.evolution_id # attach move current to super
    save_move_current # save move_current
  end

  def go_move_current_to_parent
    get_mutations # get mutations
    if @mutation_parent # if parent present
      @mutation_move_current.mutation_id = @mutation_current.mutation_id # attach move_current to parent
    else 
      if @mutation_super # if super present
        @mutation_move_current.evolution_id = @mutation_current.evolution_id # attach move_current to super
      end # end
    end # end
    @mutation_current.mutation_id = @mutation_move_current.id # attach current to move_current
    save_move_current # save move_current
  end
  def go_move_current_to_current
    get_mutations # get mutations
    if @mutation_parent # if parent present
      @mutation_move_current.mutation_id = @mutation_current.mutation_id # attach move_current to parent
    else 
      if @mutation_super # if super present
        @mutation_move_current.evolution_id = @mutation_current.evolution_id # attach move_current to super
      end # end
    end # end
    save_move_current # save move_current
  end
  def go_move_current_to_child
    get_mutations # get mutations
    @mutation_move_current.mutation_id = @mutation_current.id # attach move_current to current 
    for mutation in @mutation_current.children # for current children
      mutation.mutation_id = @mutation_move_current.id # attach child to move_current
      mutation.save # save child
    end # end
    save_move_current # save move_current
  end




  def move_mutation_to_mutation(subject, target)
    get_mutation_detached subject
    attach_mutation_to_mutation @mutation_detached target
    save_mutation @mutation_detached
  end

  def go_move_current_partial_to_root
    get_mutations
    move_mutation_to_mutation @mutation_move_current_partial @mutation_root
  end
  def go_move_current_partial_to_parent
    get_mutations
    move_mutation_to_mutation @mutation_move_current_partial @mutation_parent
  end
  def go_move_current_partial_to_current
    get_mutations
    move_mutation_to_mutation @mutation_move_current_partial @mutation_current
  end
  def go_move_current_partial_to_child
    get_mutations
    move_mutation_to_mutation @mutation_move_current_partial @mutation_child
  end
  ###... def_go_move_current_to_root|current|parent|child

  def get_mutation_clone_current # clone session set_mutation_clone_current as @mutation_clone
    mutation_current = Mutation.find(session[:set_mutation_clone_current]) # get current
    @mutation_clone = Mutation.new # get new clone
    # copy current info to clone
    @mutation_clone.save # save clone
    then_go_clone_children mutation_current, @mutation_clone # clone children of current, to new parent end
  end

  def then_go_clone_children(pass_mutation, pass_mutation_clone)
    for mutation in pass_mutation.children # for each child of current children
      mutation_clone = Mutation.new # get new clone
      mutation_clone.mutation_id = pass_mutation_clone.id # attach clone to new
      # this is where you would copy child info to clone 
      mutation_clone.save # save clone
      then_go_clone_children mutation, mutation_clone # loop forever until done
    end
  end

  def get_mutation_clone_current_partial # clone session set_mutation_clone_current_partial as @mutation_clone
    mutation_current = Mutation.find(session[:set_mutation_clone_current_partial]) # get current
    @mutation_clone = Mutation.new # get new clone
    # copy current info to clone
    @mutation_clone.save # save clone
  end
  
  def go_destroy_current
    get_mutations # get mutations
    @mutation_current.destroy # destroy current
    if @mutation_parent # if parent present
      flash_success # flash success
      redirect_to @mutation_parent # redirect to parent
    else # else
      if @mutation_super # if super present
        flash_success # flash success
        redirect_to @evolution.mutations # redirect to roots
      end # end
      flash_fail # flash fail
    end # end
  end
  def go_destroy_current_partial
    get_mutations # get mutations
    # get muatation detached
    # go destroy current
  end

  # refactor1

  def get_mutations(pass=params[:id])
    @mutation_root = @mutation_current.ancestors.last # get root
    @mutation_current = Mutation.find(pass) # get current
    @evolution = Evolution.find(@mutation_root.evolution_id)
    if @mutation_current.evolution_id
      @mutation_super = Evolution.find(@mutation_current.evolution_id)
    end # get super of current
    if @mutation_current.mutation_id
      @mutation_parent = Mutation.find(@mutation_current.mutation_id)
    end # get parent of current

    @mutation_child.mutation_id = @mutation_current.id
    @mutation_child.fake_child = true

    if session([:mutation_clone_current_id])
      @mutation_clone_current = Mutation.find(session[:mutation_clone_current_id]) 
    end # get clone_current from session
    if session([:mutation_clone_current_partial_id])
      @mutation_clone_current_partial = Mutation.find(session[:mutation_clone_current_partial_id]) 
    end # get clone_current_partial from session

    if session([:mutation_move_current_id])
      @mutation_move_current = Mutation.find(session[:mutation_move_current_id]) 
    end # get move_current from session
    if session([:mutation_move_current_partial_id])
      @mutation_move_current_partial = Mutation.find(session[:mutation_move_current_partial_id]) 
    end # get move_current_partial from session
    # @mutation_root
    # @mutation_current
    # @evolution
    # @mutation_super = @evolution
  end  
  
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                attach_mutation_to_super|parent|current
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def detach_move_current_partial # detach move_current_partial
    get_mutations
    if @mutation_parent # if parent present
      for mutation in @mutation_current.children # get children
        mutation.mutation_id = @mutation_current.mutation_id # attach children to parent
	mutation.save
      end # end
    else # else
      if @mutation_super # if super present
        for mutation in @mutation_current.children # get children
          mutation.evolution_id = @mutation_current.evolution_id # attach children to super
	  mutation.save
        end # end
      end # end
    end # end
    @mutation_move_current_partial.mutation_id = nil
    @mutation_move_current_partial.evolution_id = nil
    @mutation_move_current_partial.save
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                attach_mutation_to_super|parent|current
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_mutation(pass)
    if pass.save # save move_current_partial
      flash_success # success
      session[:mutation_move_current_partial_id] = nil # clear move
      redirect_to pass # redirect to current
    else # else
      flash_fail # fail
      redirect_to @mutation_current # redirect to current
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                attach_mutation_to_super|parent|current
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def attach_mutation_to_super(pass)
    pass.evolution_id = @mutation_super.id # attach mutation to super
    pass.mutation_id = nil # detach mutation from parent
    pass.save # save mutation
  end
  def attach_mutation_to_parent(pass)
    pass.evolution_id = nil # detach mutation from super
    pass.mutation_id = @mutation_parent.id # attach mutation to parent
    pass.save # save mutation
  end
  def attach_mutation_to_current(pass)
    pass.evolution_id = nil # detach mutation from super
    pass.mutation_id = @mutation_current.id # attach mutation to parent
    pass.save # save mutation
  end

  def get_mutation_detached(pass)
    if pass.mutation_id # if pass parent present
      for mutation in pass.children # for pass children
        mutation.evolution_id = nil # detach child from super
        mutation.mutation_id = pass.mutation_id # pass child to parent
        mutation.save # save mutation
      end # end
    else # else
    if pass.evolution_id # if pass super present
      for mutation in pass.children # for pass children
        mutation.evolution_id = pass.evolution_id # attach child to super
	mutation.mutation_id = nil # detach child from parent
        mutation.save # save mutation
      end # end
    end # end
    end # end
    @mutation_detached = pass # get mutation detach
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

  def flash_success
    flash[:notice] = "Success" # flash success
  end
  def flash_fail
    flash[:error] = "Fail, try again" # flash fail
  end

end
