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
    if @mutation.save
      flash_success   
      redirect_to @mutation
    else
      flash_fail  
      redirect_to mutations_path
    end
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
  
 
  # [toggle] edit [mode]
  #   if toggle is true
  #     switch to false
  #   elsif toggle is false
  #     switch to true
  #   end
  #   refresh
  # end
  def toggle_edit
    get_mutation
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
      flash_success
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
    flash_success
    redirect_to @mutation_parent||mutations_path
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *save 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_new
    if @mutation_new.save
      flash_success
      redirect_to @mutation_new
    else
      flash_fail
      redirect_to @mutation
    end
  end

  def save_clone
    if @mutation_clone.save
      flash_success
      session[:mutation_clone_id] = nil
      redirect_to @mutation_clone
    else
      flash_fail
      redirect_to @mutation
    end
  end
  def save_clone_uni
    if @mutation_clone_uni.save
      flash_success
      session[:mutation_clone_uni_id] = nil
      redirect_to @mutation_clone_uni
    else
      flash_fail
      redirect_to @mutation
    end
  end

  def save_move
    if @mutation_move.save
      flash_success
      session[:mutation_move_id] = nil
      redirect_to @mutation_move
    else
      flash_fail
      redirect_to @mutation
    end
  end
  def save_move_uni
    if @mutation_move_uni.save
      flash_success
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

  def copy_over(pass1, pass2)
    #...
  end
  def clone_children(pass1, pass2)
    pass1.children.each do |mutation|
      mutation_new = Mutation.new
      copy_over mutation, mutation_new
      mutation_new.save
      attach_to mutation_new, pass2
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

  def check_for_childship(pass1, pass2) # check for childship
    if pass1 == pass2 # if one equals two
      @child_or_current = true # childship false
    else
      check_for_childship_children pass1, pass2 # check children
    end
  end
  def check_for_childship_children(pass1, pass2)
    pass1.children.each do |child|
      if child == pass2
        @child_or_current = true
      end
      check_for_childship_children child, pass2
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

  def move_children_to(pass)
    @mutation.children.each do |child| # for children
      attach_to child, pass # attach child to pass
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
      flash_success
      if @mutation_parent
        redirect_to @mutation_parent
      else
        redirect_to :action => "index"
      end
    else
      flash_fail
      redirect_to @mutation
    end
  end 

# pass1 = the mutation that will be re-assigned
# pass2 = the mutation that will remain un-changed


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
  def isolate_mutation(pass1)
    if pass1.mutation_id # if pass1 has parent
      pass1_parent = Mutation.find(pass1.mutation_id) # let pass1 parent be the pass1 parent
      attach_children_to pass1, pass1_parent # attach children of pass1 to pass1 parent
    else # pass1 is root
      for mutation in pass1.children
        mutation.mutation_id = nil
        mutation.save
      end
    end # end 
    pass1.mutation_id = nil
    pass1.save
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *place 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def place_at_root(pass)
    pass.super_id = @mutation_super.id
    pass.mutation_id = nil
    pass.save
  end
  def place_at_parent(pass)
    pass.super_id = @mutation_super.id
    if @mutation_parent # if parent
      attach_to pass, @mutation_parent # attach pass to parent
      pass.save # save pass
    else # else, root
      pass.mutation_id = nil # erase parent
      pass.save # save pass
    end # end
    attach_to @mutation, pass # attach mutation to pass
    @mutation.save # save mutation to new parent
  end
  def place_at_current(pass)
    pass.super_id = @mutation_super.id
    if @mutation_parent # if parent 
      attach_to pass, @mutation_parent # attach pass to parent
    else # else, is root
      pass.mutation_id = nil # erase parent
    end # end 
    pass.save # save pass
  end
  def place_at_child(pass)
    pass.super_id = @mutation_super.id
    attach_to pass, @mutation
    pass.save
  end
  def place_at_children(pass)
    pass.super_id = @mutation_super.id
    move_children_to pass
    place_at_child pass
    pass.save
  end

 
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *attach 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def attach_to(pass1, pass2, pass2_is_super=false)
    if pass2_is_super
      pass1.mutation_id = nil
      pass1.mutation_id = pass2.id
      pass1.save
    else # pass2 is parent
      pass1.mutation_id = pass2.id
      #pass1.mutation_id = nil
      pass1.save
    end
  end
  def attach_children_to(pass1, pass2)
    for mutation in pass1.children # attach children to pass
      attach_to mutation, pass2 
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *flash 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def flash_success
    flash[:notice] = "Success" # flash success
  end
  def flash_fail
    flash[:error] = "Fail, try again" # flash fail
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *function
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
 
  def start
    @mutation = Mutation.find(params[:id])
    @mutation.start_time = Time.now
    if @mutation.save
      flash_success
      redirect_to @mutation
    else
      flash_fail
      redirect_to @mutation
    end
  end 

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *get_mutations 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def get_mutation(pass=params[:id])
    @mutation = Mutation.find(pass) # get current
  end
  def get_mutations(pass=params[:id])
    @mutation = Mutation.find(pass) # get current
    @mutation_root = @mutation.ancestors.last || @mutation # get root
    @mutation_super = Evolution.find(@mutation_root.evolution_id) #*** for testing then switch to feature id
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
  def get_agenda
    get_mutations 
    get_childless @mutation_root
    get_prioritization @mutation_super
    redirect_to :action => 'agenda', :id => @mutation.id
  end

  # get prioritization with super id
  #   get super id
  #   pre prioritizations are objects with super id and ascending ancestorizations
  #   set prioritization with ready_to_prioritize
  # end
  def get_prioritization(pass)
    mutations = Mutation.find(:all, :conditions => {:childless => true, :super_id => pass.id}, :order => "ancestorization ASC" )
    for mutation in mutations 
      set_prioritization mutation 
    end
  end

  # set prioritization with pass
  #   counter equals one
  #   prioritization equals counter
  #   save
  #   for each ancestor
  #     advance counter
  #     pioritization equals counter
  #     save
  #   end
  # end
  def set_prioritization(pass)
    counter = 1
    pass.prioritization = counter
    pass.save
    pass.ancestors.each do |ancestor|
      counter = counter + 1
      ancestor.prioritization = counter
      ancestor.save
    end
  end

  # [show] agenda
  #   get mutations
  #   mutations equals all of same super, in order of prioritization, ascending
  #   prioritization max equals max prioritization of same super
  # end
  def agenda
    get_mutations
    @mutations = Mutation.find(:all, :conditions => {:super_id => @mutation_super.id}, :order => "prioritization ASC" )
    @prioritization_max = Mutation.maximum(:prioritization, :conditions => {:super_id => @mutation_super.id} )
  end

  # locate and get childless objects of passed object
  #   get passes
  #   set childless status with pass
  #   set ancestorization with pass
  #   set super with pass
  #   if pass not childless, then
  #     for each child
  #       loop passing child
  #     end
  #   end
  # end
  def get_childless(pass) 
    pass1 = pass
    pass2 = pass
    pass3 = pass
    pass4 = pass
    set_childless_status pass1 
    set_ancestorization pass2 
    set_super pass4
    if !pass3.children.empty? 
      for child in pass3.children		 
        get_childless child
      end
    end 
  end 

  # set childless state of passed object
  #   get pass
  #   if childless, then
  #     childless is true
  #   else, not childless, so
  #     childless is false
  #   end
  #   save
  # end
  def set_childless_status(pass)
    pass1 = pass	
    if pass1.children.empty? 	
      pass1.childless = true 	
    else 			
      pass1.childless = false 	
    end 		
    pass1.save 		
  end 	

  # set ancestorization with passed object
  #   get pass
  #   pass ancestorization is ancestor size
  #   save
  # end
  def set_ancestorization(pass)
    pass1 = pass
    pass1.ancestorization = pass1.ancestors.size 
    pass1.save 
  end

  # set super with pass and pass super
  #   get pass
  #   pass super is current super
  #   save
  # end
  def set_super(pass)
    pass1 = pass
    pass1.super_id = @mutation_super.id
    pass1.save
  end











































end
