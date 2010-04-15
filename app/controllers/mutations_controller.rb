class MutationsController < ApplicationController

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *basics
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def index
    @mutations = Mutation.all
  end
  
  def show
    get_mutations
  end
 
  def create
    @mutation = Mutation.new(params[:mutation])
    if @mutation.save
      flash_success @mutation
      redirect_to @mutation
    else
      render :action => 'new'
    end
  end
  
 
  # [toggle] edit [mode]
  #   if toggle is true
  #     switch to false
  #   elsif toggle is false
  #     switch to true
  #   end
  #   refresh
  # end
  def toggle_edit
    get_mutations
    if session[:edit] == true
      session[:edit] = false
    else
      session[:edit] = true 
    end
    redirect_to @mutation
  end

  def update
    @mutation = Mutation.find(params[:id])
    if @mutation.update_attributes(params[:mutation])
      flash_success @mutation
      session[:edit] = false
      redirect_to @mutation
    else
      flash_fail
      redirect_to @mutation
    end
  end
  
  def destroy
    get_mutations
    @mutation.destroy
    flash_success @mutation_parent
    redirect_to @mutation_parent||mutations_path
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *save 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_new
    if @mutation_new.save
      flash_success @mutation_new
      redirect_to @mutation_new
    else
      flash_fail
      redirect_to @mutation
    end
  end

  def save_clone
    if @mutation_clone.save
      flash_success @mutation_clone
      session[:mutation_clone_id] = nil
      redirect_to @mutation_clone
    else
      flash_fail
      redirect_to @mutation
    end
  end
  def save_clone_uni
    if @mutation_clone_uni.save
      flash_success @mutation_clone_uni
      session[:mutation_clone_uni_id] = nil
      redirect_to @mutation_clone_uni
    else
      flash_fail
      redirect_to @mutation
    end
  end

  def save_move
    if @mutation_move.save
      flash_success @mutation_move
      session[:mutation_move_id] = nil
      redirect_to @mutation_move
    else
      flash_fail
      redirect_to @mutation
    end
  end
  def save_move_uni
    if @mutation_move_uni.save
      flash_success @mutation_move_uni
      session[:mutation_move_uni_id] = nil
      redirect_to @mutation_move_uni
    else
      flash_fail
      redirect_to @mutation
    end
  end
  

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *new
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
   
  # new 
  #   find evolution by params
  #   new evolution mutation
  #   if mutation save
  #     flash success
  #     goto mutation
  #   else, mutation save not
  #     flash fail
  #     go to mutations index
  #   end
  # end
  def new
    @evolution = Evolution.find(params[:evolution_id])
    @mutation = @evolution.mutations.new
    @mutation.super_id = @evolution.id
    if @mutation.save
      flash_success @mutation
      redirect_to @mutation
    else
      flash_fail  
      redirect_to mutations_path
    end
  end
 
  # new root
  #   get mutations
  #   get new
  #   place new at root
  #   save
  # end
  def new_root
    get_mutations
    @mutation_new = @mutation_super.mutations.new
    @mutation_new.super_id = @mutation_super.id
    @mutation_new.evolution_id = @mutation_super.id
    place_at_root @mutation_new
    save_new
  end
  def new_parent
    get_mutations
    @mutation_new = Mutation.new
    @mutation_new.super_id = @mutation_super.id
    place_at_parent @mutation_new
    save_new
  end
  def new_current
    get_mutations
    @mutation_new = Mutation.new
    @mutation_new.super_id = @mutation_super.id
    place_at_current @mutation_new
    save_new
  end
  def new_children
    get_mutations
    @mutation_new = Mutation.new
    @mutation_new.super_id = @mutation_super.id
    place_at_children @mutation_new
    save_new
  end
  def new_child
    get_mutations
    @mutation_new = Mutation.new
    @mutation_new.super_id = @mutation_super.id
    place_at_child @mutation_new
    save_new
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *set
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def set_clone
    get_mutations
    session[:mutation_clone_id] = @mutation.id # set clone
    redirect_to @mutation # redirect to current
  end
  def set_clone_uni
    get_mutations
    session[:mutation_clone_uni_id] = @mutation.id # set clone uni
    redirect_to @mutation # redirect to current
  end
  def set_move
    get_mutations
    session[:mutation_move_id] = @mutation.id # set move
    redirect_to @mutation # redirect to current
  end
  def set_move_uni
    get_mutations
    session[:mutation_move_uni_id] = @mutation.id # set move uni
    redirect_to @mutation # redirect to current
  end

  def move_to_move_uni
    get_mutations
    session[:mutation_move_uni_id] = session[:mutation_move_id] # set uni to normal
    session[:mutation_move_id] = nil # nil normal
    redirect_to @mutation # redirect to current
  end
  def move_uni_to_move
    get_mutations
    session[:mutation_move_id] = session[:mutation_move_uni_id] # set uni to normal
    session[:mutation_move_uni_id] = nil # nil normal
    redirect_to @mutation # redirect to current
  end
  
  def clone_to_clone_uni
    get_mutations
    session[:mutation_clone_uni_id] = session[:mutation_clone_id] # set uni to normal
    session[:mutation_clone_id] = nil # nil normal
    redirect_to @mutation # redirect to current
  end
  def clone_uni_to_clone
    get_mutations
    session[:mutation_clone_id] = session[:mutation_clone_uni_id] # set uni to normal
    session[:mutation_clone_uni_id] = nil # nil normal
    redirect_to @mutation # redirect to current
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *cancel
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def cancel_clone
    get_mutations
    session[:mutation_clone_id]=nil # clear session
    redirect_to @mutation # redirect to current
  end
  def cancel_clone_uni
    get_mutations
    session[:mutation_clone_uni_id]=nil # clear session
    redirect_to @mutation # redirect to current
  end
  def cancel_move
    get_mutations
    session[:mutation_move_id]=nil # clear session
    redirect_to @mutation # redirect to current
  end
  def cancel_move_uni
    get_mutations
    session[:mutation_move_uni_id]=nil # clear session
    redirect_to @mutation # redirect to current
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *clone
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def copy_over(thing_one, thing_two)
    #...
  end
  def clone_children(thing_one, thing_two)
    thing_one.children.each do |mutation|
      mutation_new = Mutation.new
      copy_over mutation, mutation_new
      mutation_new.save
      attach_to mutation_new, thing_two
      clone_children mutation, mutation_new
    end
  end

  def make_clone
    get_mutations
    mutation_new = Mutation.new
    mutation_new.save
    copy_over @mutation_clone, mutation_new
    clone_children @mutation_clone, mutation_new
    @mutation_clone = mutation_new
  end
  def make_clone_uni
    get_mutations
    mutation_clone_uni = Mutation.new
    copy_over mutation_clone_uni, @mutation_clone_uni
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
  def clone_to_children
    make_clone
    place_at_children @mutation_clone
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
    isolate_mutation @mutation_move_uni
    place_at_current @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_mutations
    isolate_mutation @mutation_move_uni
    place_at_child @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_children
    get_mutations
    isolate_mutation @mutation_move_uni
    place_at_children @mutation_move_uni
    save_move_uni
  end
  def clone_uni_to_children
    make_clone_uni
    place_at_children @mutation_clone_uni
    save_clone_uni
  end
  def clone_uni_to_child
    make_clone
    place_at_child @mutation_clone_uni
    save_clone
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *move
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def check_for_childship(thing_one, thing_two) # check for childship
    if thing_one == thing_two # if thing_one equals thing_two
      @child_or_current = true # childship false
    else
      check_for_childship_children thing_one, thing_two # check children
    end
  end
  def check_for_childship_children(thing_one, thing_two)
    thing_one.children.each do |child|
      if child == thing_two
        @child_or_current = true
      end
      check_for_childship_children child, thing_two
    end
  end
    
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
  def move_to_children
    get_mutations
    place_at_children @mutation_move
    save_move
  end
  def move_to_child
    get_mutations # get mutations
    place_at_child @mutation_move # place move at child position
    save_move # save move
  end

  def move_children_to(thing_one)
    @mutation.children.each do |child| # for children
      attach_to child, thing_one # attach child to thing_one
    end # end
  end

  def move_uni_to_root
    get_mutations
    isolate_mutation @mutation_move_uni
    place_at_root @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_parent
    get_mutations
    isolate_mutation @mutation_move_uni
    place_at_parent @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_current
    get_mutations
    isolate_mutation @mutation_move_uni
    place_at_current @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_mutations
    isolate_mutation @mutation_move_uni
    place_at_child @mutation_move_uni
    save_move_uni
  end
  def move_uni_to_children
    get_mutations
    isolate_mutation @mutation_move_uni
    place_at_children @mutation_move_uni
    save_move_uni
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *destroy
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def destroy
    get_mutations
    if @mutation.destroy
      if @mutation_parent
        flash_success @mutation_parent
        redirect_to @mutation_parent
      else
        flash_success
        redirect_to :action => "index"
      end
    else
      flash_fail
      redirect_to @mutation
    end
  end 

# thing_one = the mutation that will be re-assigned
# thing_two = the mutation that will remain un-changed


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *isolate 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  # isolate object
  #   if object has a parent
  #     get parent
  #     attach object children to parent
  #   else, if object has super
  #     for each object child
  #       
  #       
  #       save
  #     end
  #   end
  #
  #
  def isolate_mutation(thing_one)
    if thing_one.mutation_id # if thing_one has parent
      thing_one_parent = Mutation.find(thing_one.mutation_id) # let thing_one parent be the thing_one parent
      attach_children_to thing_one, thing_one_parent # attach children of thing_one to thing_one parent
    else # thing_one is root
      for mutation in thing_one.children
        mutation.mutation_id = nil
        mutation.save
      end
    end # end 
    thing_one.mutation_id = nil
    thing_one.save
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *place 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  # place at root
  #   super id to mutation super
  #   evolution id to super
  #   mutation id to nil
  #   save
  # end
  def place_at_root(thing_one)
    thing_one.super_id = @mutation_super.id
    thing_one.evolution_id = @mutation_super.id
    thing_one.mutation_id = nil
    thing_one.save
  end
  
  # place at parent
  #   set super id to super
  #   if parent
  #     attach it to parent
  #     save
  #   else, root
  #     attach it to super
  #     nil parent
  #     save
  #   end
  #   attach mutation to thing_one
  #   save
  # end
  def place_at_parent(thing_one)
    thing_one.super_id = @mutation_super.id
    if @mutation_parent
      attach_to thing_one, @mutation_parent
      thing_one.save
    elsif @mutation == @mutation_root 
      thing_one.evolution_id = @mutation_super.id
      thing_one.mutation_id = nil
      thing_one.save
    end
    attach_to @mutation, thing_one
    @mutation.save
  end
  
  # place at current
  #   set super id to super
  #   if parent
  #     attach it to parent
  #     save
  #   elsif root
  #     attach it to super
  #     erase parent
  #     save
  #   end
  #   save
  # end 
  def place_at_current(thing_one)
    thing_one.super_id = @mutation_super.id
    if @mutation_parent
      attach_to thing_one, @mutation_parent
      thing_one.save
    else 
      thing_one.evolution_id = @mutation_super
      thing_one.mutation_id = nil
      thing_one.save
    end  
    thing_one.save
  end


  def place_at_child(thing_one)
    thing_one.super_id = @mutation_super.id
    attach_to thing_one, @mutation
    thing_one.save
  end
  def place_at_children(thing_one)
    thing_one.super_id = @mutation_super.id
    move_children_to thing_one
    place_at_child thing_one
    thing_one.save
  end

 
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *attach 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  # attach thing_one to thing_two, optional: thing_two is super
  #   set thing_one super to super
  #   if thing_two is super
  #     set thing_one evolution to super
  #     set thing_one mutation to nil
  #   else, thing_two not super
  #     set thing_one mutation to thing_two
  #   end
  #   save thing_one
  # end
  def attach_to(thing_one, thing_two, thing_two_is_super=false)
    thing_one.super_id = @mutation_super.id
    if thing_two_is_super
      thing_one.evolution_id = @mutation_super.id
      thing_one.mutation_id = nil 
    else 
      thing_one.mutation_id = thing_two.id
    end
    thing_one.save
  end

  # attach children of thing_one to thing_two
  #   for each thing_one child
  #     attach child to thing_two
  #   end
  # end
  def attach_children_to(thing_one, thing_two)
    thing_one.children.each do |child| 
      attach_to child, thing_two
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *flash 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def flash_success(one=nil)
    if one
      get_prioritization one
    end
    flash[:notice] = "Success" # flash success
  end
  def flash_fail
    flash[:error] = "Fail, try again" # flash fail
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *get_mutations 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def get_mutations(thing_one=params[:id])
    @mutation = Mutation.find(thing_one) # get current
    @mutation_root = @mutation.ancestors.last || @mutation # get root
    @mutation_super = Evolution.find(@mutation.super_id) #*** for testing then switch to feature id
    if @mutation.mutation_id
      @mutation_parent = Mutation.find(@mutation.mutation_id)
    end # get parent of current
    if session[:mutation_clone_id]
      @mutation_clone = Mutation.find(session[:mutation_clone_id]) 
    end # get clone_current from session
    if session[:mutation_clone_uni_id]
      @mutation_clone_uni = Mutation.find(session[:mutation_clone_uni_id]) 
    end # get clone_current_uni from session
    if session[:mutation_move_id]
      @mutation_move = Mutation.find(session[:mutation_move_id]) 
      if @mutation # if current
        check_for_childship @mutation_move, @mutation # check for childship
      end # end
    end # get move_current from session
    if session[:mutation_move_uni_id]
      @mutation_move_uni = Mutation.find(session[:mutation_move_uni_id]) 
      if @mutation # if current
        check_for_childship @mutation_move_uni, @mutation # check for childship
      end # end
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *agenda
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 


  # get the prioritized mutations lists
  #   get mutations
  #   get childless with root
  #   set prioritization with super
  #   redirect to action, agenda, id is mutation id
  # end
  def prioritize
    get_mutations 
    get_prioritization @mutation
    redirect_to :action => 'agenda', :id => @mutation.id
  end

  # [show] agenda
  #   get mutations
  # end
  def agenda
    get_mutations
  end











































end
