class MutationsController < ApplicationController

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# new | clone | move | destroy
# current | current_single
# root | parent | current | child
# new: root | parent | current | child

# clone: current | current_single
# move: current | current_single

# clone_current_to: root | parent | current | child | cancel
# clone_current_single_to: root | parent | current | child | cancel

# move_current_to: root | parent | current | child | cancel
# move_current_single_to: root | parent | current | child | cancel

# destroy: current | current_single
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 basics
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

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

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   new
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

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

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   set
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def set_clone_current
    go_set_clone_current
  end
  def set_clone_current_single
    go_set_clone_current_single
  end
  def set_move_current
    go_set_move_current
  end
  def set_move_current_single
    go_set_move_current_single
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  cancel
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def cancel_clone_current
    go_cancel_clone_current
  end
  def cancel_clone_current_single
    go_cancel_clone_current_single
  end
  def cancel_move_current
    go_cancel_move_current
  end
  def cancel_move_current_single
    go_cancel_move_current_single
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  clone
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_clone
    if @mutation_clone.save
      flash_success
      session[:mutation_clone_id] = nil
      redirect_to @mutation_clone
    else
      flash_fail
      redirect_to @mutation_current
    end
  end
  
  def save_clone_single
    if @mutation_clone.save
      flash_success
      session[:mutation_clone_single_id] = nil
      redirect_to @mutation_clone_single
    else
      flash_fail
      redirect_to @mutation_current
    end
  end

  def clone_from(object, is_single=false)
    @mutation_clone = Mutation.new
    if is_single
      copy_over_to @mutation_clone, object
      save_clone
    else # is many
      clone_children_from object
    end
    #save_clone
    ############################
  end

  def clone_children_from(object, object_parent)
    for mutation in object.children
      mutation_clone = Mutation.new
      copy_over_to mutation_clone, mutation
      mutation_clone.save
      clone_children_from mutation, mutation_clone
    end
    save_clone
  end

  def copy_over_to(subject, object)
  end
  
  def clone_to_root
    go_clone_to_root
  end
  def clone_to_parent
    go_clone_to_parent
  end
  def clone_to_current
    go_clone_to_current
  end
  def clone_current_to_child
    go_clone_to_child
  end

  def clone_single_to_root
    go_clone_single_to_root
  end
  def clone_single_to_parent
    go_clone_single_to_parent
  end
  def clone_single_to_current
    go_clone_single_to_current
  end
  def clone_single_to_child
    go_clone_single_to_child
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   move
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_move
    if @mutation_move.save
      flash_success
      session[:mutation_move_id] = nil
      redirect_to @mutation_move
    else
      flash_fail
      redirect_to @mutation_current
    end
  end
  
  def save_move_single
    if @mutation_move.save
      flash_success
      session[:mutation_move_single_id] = nil
      redirect_to @mutation_move_single
    else
      flash_fail
      redirect_to @mutation_current
    end
  end
  
  def move_to_root
    get_mutations
    @mutation_move.evolution_id = @mutation_root.evolution_id
    @mutation_move.mutation_id = nil
    save_move
  end
  def move_to_parent
    get_mutations
    if @mutation_super # if super
      attach_to @mutation_move, @mutation_super, true
    else # @mutation_parent
      attach_to @mutation_move, @mutation_parent
    end
    attach_to @mutation_current, @mutation_move
    save_move
  end
  def move_to_current
    get_mutations
    if @mutation_super # if super
      attach_to @mutation_move, @mutation_super, true
    else # @mutation_parent
      attach_to @mutation_move, @mutation_parent
    end
    save_move
  end
  def move_to_child
    attach_to @mutation_move, @mutation_current
    save_move
  end

  def move_single_to_root
    get_mutations
    singleize_mutation @mutation_move_single
    @mutation_move_single.evolution_id = @mutation_root.evolution_id
    @mutation_move_single.mutation_id = nil
    save_move_single
  end
  def move_single_to_parent
    get_mutations
    singleize_mutation @mutation_move_single
    if @mutation_super # if super
      attach_to @mutation_move_single, @mutation_super, true
    else # @mutation_parent
      attach_to @mutation_move_single, @mutation_parent
    end
    attach_to @mutation_current, @mutation_move_single
    save_move_single
  end
  def move_single_to_current
    get_mutations
    singleize_mutation @mutation_move_single
    if @mutation_super # if super
      attach_to @mutation_move_single, @mutation_super, true
    else # @mutation_parent
      attach_to @mutation_move_single, @mutation_parent
    end
    save_move
  end
  def move_single_to_child
    get_mutations
    singleize_mutation @mutation_move_single
    attach_to @mutation_move_single, @mutation_current
    save_move
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 destroy
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def destroy_current
    get_mutations
    if @mutation_current.destroy
      flash_success
      if @mutation_parent
        redirect_to @mutation_parent
      else
        redirect_to :action => "index"
      end
    else
      flash_fail
      redirect_to @mutation_current
    end
  end
  def destroy_current_single
    get_mutations
    singleize_mutation @mutation_current
    if @mutation_current.destroy
      flash_success
      if @mutation_parent
        redirect_to @mutation_parent
      else
        redirect_to :action => "index"
      end
    else
      flash_fail
      redirect_to @mutation_current
    end
  end

#protected

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 helpers                     
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

# get_mutations
# @mutation_super(if exists)
# @mutation_root
# @mutation_parent(if exists)
# @mutation_current
# @mutation_move_current(if exists)
# @mutation_move_current_single(if exists)
# @mutation_clone_current(if exists)
# @mutation_clone_current_single(if exists)

  def get_mutations(pass=params[:id])
    @mutation_root = @mutation_current.ancestors.last # get root
    @mutation_current = Mutation.find(pass) # get current
    if @mutation_current.evolution_id
      @mutation_super = Evolution.find(@mutation_current.evolution_id)
    end # get super of current
    if @mutation_current.mutation_id
      @mutation_parent = Mutation.find(@mutation_current.mutation_id)
    end # get parent of current

    if session([:mutation_clone_id])
      @mutation_clone = Mutation.find(session[:mutation_clone_id]) 
    end # get clone_current from session
    if session([:mutation_clone_single_id])
      @mutation_clone_single = Mutation.find(session[:mutation_clone_single_id]) 
    end # get clone_current_single from session

    if session([:mutation_move_id])
      @mutation_move = Mutation.find(session[:mutation_move_id]) 
    end # get move_current from session
    if session([:mutation_move_single_id])
      @mutation_move_single = Mutation.find(session[:mutation_move_single_id]) 
    end
  end

# subject = the mutation that will be re-assigned
# object = the mutation that will remain un-changed
# whole = indicates if the subject includes all children

  def singleize_mutation(subject)
    if subject.mutation_id # if subject has parent
      subject_parent = Mutation.find(subject.mutation_id)
      attach_children_to subject, subject_parent
    else # subject has super
      subject_super = Evolution.find(subject.evolution_id)
      attach_children_to subject, subject_super
    end
    subject.mutation_id = evolution_id = nil
    subject.save
  end

  def attach_to(subject, object, object_is_super=false)
    if object_is_super
      subject.mutation_id = nil
      subject.evolution_id = object.id
      subject.save
    else # object is parent
      subject.mutation_id = object.id
      subject.evolution_id = nil
      subject.save
    end
  end

  def attach_children_to(subject, object, object_is_super=false)
    if object_is_super
      for mutation in subject.children
        attach_to mutation, object, object_is_super
      end
    else # object is parent
      for mutation in subject.children
        attach_to mutation, object 
      end
    end
  end

  def flash_success
    flash[:notice] = "Success" # flash success
  end
  def flash_fail
    flash[:error] = "Fail, try again" # flash fail
  end

end
