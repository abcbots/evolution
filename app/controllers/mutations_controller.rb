class MutationsController < ApplicationController

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# Mutation: Tree | New | Clone | Move | Destroy # layouts/mutations/menu
#
# New: Root | Parent | Current | Child # layouts/mutatons/new
# Clone Current: Complete | One # layouts/mutations/clone
# Move Current: Complete | One # layouts/mutations/move
# Destroy Current: Complete | One # layouts/mutations/destroy
#
# Clone to: Root | Parent | Current | Child | Cancel # layouts/mutations/clone_to
# Clone uni to: Root | Parent | Current | Child | Cancel # layouts/mutations/clone_uni_to
# Move to: Root | Parent | Current | Child | Cancel # layouts/mutations/move_to
# Move uni to: Root | Parent | Current | Child | Cancel # layouts/mutations/move_uni_to
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 basics
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def index
    @evolution = Evolution.find(params[:evolution_id]
    @mutations = @evolution.mutations.all
  end
  def show
    get_mutations
  end
  def update
    if @mutation_current.update_attributes(params[:mutation])
      flash_success
      redirect_to @mutation_current
    else
      flash_fail
      redirect_to @mutation_current
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   save 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_new
    if @mutation_new.save
      flash_success
      redirect_to @mutation_new
    else
      flash_fail
      redirect_to @mutation_current
    end
  end

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
  def save_clone_uni
    if @mutation_clone_uni.save
      flash_success
      session[:mutation_clone_uni_id] = nil
      redirect_to @mutation_clone_uni
    else
      flash_fail
      redirect_to @mutation_current
    end
  end

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
  def save_move_uni
    if @mutation_move_uni.save
      flash_success
      session[:mutation_move_uni_id] = nil
      redirect_to @mutation_move_uni
    else
      flash_fail
      redirect_to @mutation_current
    end
  end
  

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   new
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def new_root
    get_mutations
    @mutation_new = Mutation.new
    place_at_root @mutation_new
    save_new
  end
  def new_parent
    get_mutations
    @mutation_new = Mutation.new
    place_at_parent @mutation_new
    save_new
  end
  def new_current
    get_mutations
    @mutation_new = Mutation.new
    place_at_current @mutation_new
    save_new
  end
  def new_child
    get_mutations
    @mutation_new = Mutation.new
    place_at_child @mutation_new
    save_new
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   set
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def set_clone
    get_mutations
    session[:mutation_clone_id] = @mutation_current.id # set clone
    redirect_to @mutation_current # redirect to current
  end
  def set_clone_uni
    get_mutations
    session[:mutation_clone_uni_id] = @mutation_current.id # set clone uni
    redirect_to @mutation_current # redirect to current
  end
  def set_move
    get_mutations
    session[:mutation_move_id] = @mutation_current.id # set move
    redirect_to @mutation_current # redirect to current
  end
  def set_move_uni
    get_mutations
    session[:mutation_move_uni_id] = @mutation_current.id # set move uni
    redirect_to @mutation_current # redirect to current
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  cancel
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def cancel_clone
    get_mutations
    session[:mutation_clone_id]=nil # clear session
    redirect_to @mutation_current # redirect to current
  end
  def cancel_clone_uni
    get_mutations
    session[:mutation_clone_uni_id]=nil # clear session
    redirect_to @mutation_current # redirect to current
  end
  def cancel_move
    get_mutations
    session[:mutation_move_id]=nil # clear session
    redirect_to @mutation_current # redirect to current
  end
  def cancel_move_uni
    get_mutations
    session[:mutation_move_uni_id]=nil # clear session
    redirect_to @mutation_current # redirect to current
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  clone
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def copy_over_to_from(subject_to, object_from)
    #copy script
  end
  def clone_children_to_from(subject_to, object_from)
    for mutation in object_from.children
      mutation_clone = Mutation.new
      copy_over_to_from mutation_clone, mutation
      mutation_clone.save
      clone_children_to_from mutation_clone, mutation
    end
  end

  def make_clone
    get_mutations
    mutation_clone = Mutation.new
    copy_over_to_from mutation_clone, @mutation_clone
    mutation_clone.save
    clone_children_to_from mutation_clone, @mutation_clone
    @mutation_clone = mutation_clone
  end
  def make_clone_uni
    get_mutations
    mutation_clone_uni = Mutation.new
    copy_over_to_from mutation_clone_uni, @mutation_clone_uni
    @mutation_clone_uni = mutation_clone_uni
  end

  def clone_to_root
    make_clone
    place_at_root @mutation_clone
    save_clone
  end
  def clone_to_parent
    make_clone
    place_at_parent @mutation_clone
    save_clone
  end
  def clone_to_current
    make_clone
    place_at_current @mutation_clone
    save_clone
  end
  def clone_to_child
    make_clone
    place_at_child @mutation_clone
    save_clone
  end
  
  def clone_uni_to_root
    make_clone_uni
    place_at_root @mutation_clone_uni
    save_clone_uni
  end
  def clone_uni_to_parent
    make_clone_uni
    place_at_parent @mutation_clone_uni
    save_clone_uni
  end
  def clone_uni_to_current
    make_clone_uni
    place_at_current @mutation_clone_uni
    save_clone_uni
  end
  def clone_uni_to_child
    make_clone_uni
    place_at_child @mutation_clone_uni
    save_clone_uni
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   move
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def move_to_root
    get_mutations
    place_at_root @mutation_move
    save_move
  end
  def move_to_parent
    get_mutations
    place_at_parent @mutation_move
    save_move
  end
  def move_to_current
    get_mutations
    place_at_current @mutation_move
    save_move
  end
  def move_to_child
    get_mutations
    place_at_child @mutation_move
    save_move
  end

  def move_uni_to_root
    get_mutations
    distill_mutation @mutation_move_uni
    place_at_root @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_parent
    get_mutations
    distill_mutation @mutation_move_uni
    place_at_parent @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_current
    get_mutations
    distill_mutation @mutation_move_uni
    place_at_current @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_mutations
    distill_mutation @mutation_move_uni
    place_at_child @mutation_move_uni
    save_move_uni
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
  def destroy_current_uni
    get_mutations
    distill_mutation @mutation_current
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

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 place_at 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def place_at_root(subject)
    subject.evolution_id = @mutation_root.evolution_id
    subject.mutation_id = nil
    subject.save
  end
  def place_at_parent(subject)
    if @mutation_super # if super
      attach_to subject, @mutation_super, true
    else # @mutation_parent
      attach_to subject, @mutation_parent
    end
    attach_to @mutation_current, subject
    @mutation_current.save
    subject.save
  end
  def place_at_current(subject)
    if @mutation_super # if super
      attach_to subject, @mutation_super, true
    else # @mutation_parent
      attach_to subject, @mutation_parent
    end
    subject.save
  end
  def place_at_child(subject)
    attach_children_to @mutation_current, subject
    attach_to subject, @mutation_current
    subject.save
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                              get_mutations 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 


# get_mutations
# @mutation_super(if exists)
# @mutation_root
# @mutation_parent(if exists)
# @mutation_current
# @mutation_move(if exists)
# @mutation_move_uni(if exists)
# @mutation_clone(if exists)
# @mutation_clone_uni(if exists)

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
    if session([:mutation_clone_uni_id])
      @mutation_clone_uni = Mutation.find(session[:mutation_clone_uni_id]) 
    end # get clone_current_uni from session
    if session([:mutation_move_id])
      @mutation_move = Mutation.find(session[:mutation_move_id]) 
    end # get move_current from session
    if session([:mutation_move_uni_id])
      @mutation_move_uni = Mutation.find(session[:mutation_move_uni_id]) 
    end
  end

# subject = the mutation that will be re-assigned
# object = the mutation that will remain un-changed
# whole = indicates if the subject includes all children

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 distill 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def distill_mutation(subject)
    if subject.mutation_id # if subject has parent
      subject_parent = Mutation.find(subject.mutation_id)
      attach_children_to subject, subject_parent
    else # subject has super
      subject_super = Evolution.find(subject.evolution_id)
      attach_children_to subject, subject_super, true
    end
    subject.mutation_id = subject.evolution_id = nil
    subject.save
  end
  
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  attach 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

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

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  flash 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def flash_success
    flash[:notice] = "Success" # flash success
  end
  def flash_fail
    flash[:error] = "Fail, try again" # flash fail
  end

end
