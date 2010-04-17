class EvolutionsController < ApplicationController

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *basics
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def index
    @objects = Evolution.all
  end
  
  def show
    get_evolutions
  end
   
  def new
    @object_current = Evolution.new
    if @object.save
      flash_success @object
      redirect_to @object
    else
      flash_fail  
      redirect_to evolutions_path
    end
  end
  
  def create
    @object_current = Evolution.new(params[:evolution])
    if @object.save
      flash_success @object
      redirect_to @object
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
    get_evolution
    toggle_edit_logic @object
  end

  def update
    get_evolution
    if @object.update_attributes(params[:evolution])
      flash_success @object
      session[:edit] = false
      redirect_to @object
    else
      flash_fail
      redirect_to @object
    end
  end
  
  def destroy
    get_evolutions
    @object.destroy
    flash_success @object
    redirect_to @object_parent||evolutions_path
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *save 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_new
    if @object_new.save
      flash_success @object_new
      redirect_to @object_new
    else
      flash_fail
      redirect_to @object
    end
  end

  def save_clone
    if @object_clone.save
      flash_success @object_clone
      session[:evolution_clone_id] = nil
      redirect_to @object_clone
    else
      flash_fail
      redirect_to @object
    end
  end
  def save_clone_uni
    if @object_clone_uni.save
      flash_success @object_clone_uni
      session[:evolution_clone_uni_id] = nil
      redirect_to @object_clone_uni
    else
      flash_fail
      redirect_to @object
    end
  end

  def save_move
    if @object_move.save
      flash_success @object_move
      session[:evolution_move_id] = nil
      redirect_to @object_move
    else
      flash_fail
      redirect_to @object
    end
  end
  def save_move_uni
    if @object_move_uni.save
      flash_success @object_move_uni
      session[:evolution_move_uni_id] = nil
      redirect_to @object_move_uni
    else
      flash_fail
      redirect_to @object
    end
  end
  

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *new
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def new_root
    get_evolutions
    get_evolution_new
    place_at_root @object_new, @object_super
    save_new
  end
  def new_parent
    get_evolutions
    get_evolution_new
    place_at_parent @object_current, @object_new, @object_parent, @object_super
    save_new
  end
  def new_current
    get_evolutions
    get_evolution_new
    place_at_current @object_new
    save_new
  end
  def new_children
    get_evolutions
    get_evolution_new
    @object_new.save
    place_at_children @object_new
    save_new
  end
  def new_child
    get_evolutions
    get_evolution_new
    place_at_child @object_new
    save_new
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *set
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def set_clone
    get_evolutions
    session[:evolution_clone_id] = @object.id # set clone
    redirect_to @object_current # redirect to current
  end
  def set_clone_uni
    get_evolutions
    session[:evolution_clone_uni_id] = @object.id # set clone uni
    redirect_to @object_current # redirect to current
  end
  def set_move
    get_evolutions
    session[:evolution_move_id] = @object.id # set move
    redirect_to @object_current # redirect to current
  end
  def set_move_uni
    get_evolutions
    session[:evolution_move_uni_id] = @object.id # set move uni
    redirect_to @object_current # redirect to current
  end

  def move_to_move_uni
    get_evolutions
    session[:evolution_move_uni_id] = session[:evolution_move_id] # set uni to normal
    session[:evolution_move_id] = nil # nil normal
    redirect_to @object_current # redirect to current
  end
  def move_uni_to_move
    get_evolutions
    session[:evolution_move_id] = session[:evolution_move_uni_id] # set uni to normal
    session[:evolution_move_uni_id] = nil # nil normal
    redirect_to @object_current # redirect to current
  end
  
  def clone_to_clone_uni
    get_evolutions
    session[:evolution_clone_uni_id] = session[:evolution_clone_id] # set uni to normal
    session[:evolution_clone_id] = nil # nil normal
    redirect_to @object_current # redirect to current
  end
  def clone_uni_to_clone
    get_evolutions
    session[:evolution_clone_id] = session[:evolution_clone_uni_id] # set uni to normal
    session[:evolution_clone_uni_id] = nil # nil normal
    redirect_to @object_current # redirect to current
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *cancel
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def cancel_clone
    get_evolutions
    session[:evolution_clone_id]=nil # clear session
    redirect_to @object_current # redirect to current
  end
  def cancel_clone_uni
    get_evolutions
    session[:evolution_clone_uni_id]=nil # clear session
    redirect_to @object_current # redirect to current
  end
  def cancel_move
    get_evolutions
    session[:evolution_move_id]=nil # clear session
    redirect_to @object_current # redirect to current
  end
  def cancel_move_uni
    get_evolutions
    session[:evolution_move_uni_id]=nil # clear session
    redirect_to @object_current # redirect to current
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *clone
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def clone_children(pass1, pass2)
    pass1.children.each do |evolution|
      evolution_new = Evolution.new
      copy_over evolution, evolution_new
      evolution_new.save
      attach_to evolution_new, pass2
      clone_children evolution, evolution_new
    end
  end

  def make_clone
    get_evolutions
    evolution_new = Evolution.new
    evolution_new.save
    copy_over @object_clone, evolution_new
    clone_children @object_clone, evolution_new
    clone_mutations @object_clone, evolution_new
#...here
    @object_clone = evolution_new
  end
  def make_clone_uni
    get_evolutions
    evolution_clone_uni = Evolution.new
    copy_over evolution_clone_uni, @object_clone_uni
    @object_clone_uni = evolution_clone_uni
  end

  def clone_to_root
    make_clone
    place_at_root @object_clone, @object_super
    save_clone
  end
  def clone_to_parent
    make_clone
    place_at_parent @object_current, @object_clone, @object_parent, @object_super
    save_clone
  end
  def clone_to_current
    make_clone
    place_at_current @object_clone
    save_clone
  end
  def clone_to_children
    make_clone
    place_at_children @object_clone
    save_clone
  end
  def clone_to_child
    make_clone
    place_at_child @object_clone
    save_clone
  end
  
  def clone_uni_to_root
    make_clone_uni
    place_at_root @object_clone_uni, @object_super
    save_clone_uni
  end
  def clone_uni_to_parent
    make_clone_uni
    place_at_parent @object_current, @object_clone_uni, @object_parent, @object_super
    save_clone_uni
  end
  def clone_uni_to_current
    make_clone_uni
    isolate_evolution @object_move_uni
    place_at_current @object_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_evolutions
    isolate_evolution @object_move_uni
    place_at_child @object_move_uni
    save_move_uni
  end
  def move_uni_to_children
    get_evolutions
    isolate_evolution @object_move_uni
    place_at_children @object_move_uni
    save_move_uni
  end
  def clone_uni_to_children
    make_clone_uni
    place_at_children @object_clone_uni
    save_clone_uni
  end
  def clone_uni_to_child
    make_clone
    place_at_child @object_clone_uni
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
    get_evolutions
    place_at_root @object_move
    save_move
  end
  def move_to_parent
    get_evolutions
    place_at_parent @object_current, @object_move, @object_parent, @object_super
    save_move
  end
  def move_to_current
    get_evolutions
    place_at_current @object_move
    save_move
  end
  def move_to_children
    get_evolutions
    place_at_children @object_move
    save_move
  end
  def move_to_child
    get_evolutions # get evolutions
    place_at_child @object_move # place move at child position
    save_move # save move
  end

  def move_children_to(pass)
    @object.children.each do |child| # for children
      attach_to child, pass # attach child to pass
    end # end
  end

  def move_uni_to_root
    get_evolutions
    isolate_evolution @object_move_uni
    place_at_root @object_move_uni, @object_super
    save_move_uni
  end
  def move_uni_to_parent
    get_evolutions
    isolate_evolution @object_move_uni
    place_at_parent @object_current, @object_move_uni, @object_parent, @object_super
    save_move_uni
  end
  def move_uni_to_current
    get_evolutions
    isolate_evolution @object_move_uni
    place_at_current @object_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_evolutions
    isolate_evolution @object_move_uni
    place_at_child @object_move_uni
    save_move_uni
  end
  def move_uni_to_children
    get_evolutions
    isolate_evolution @object_move_uni
    place_at_children @object_move_uni
    save_move_uni
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *destroy
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  # destroy
  #   get evolutions
  #   if destroy
  #     flass success
  #     if parent
  #       goto parent
  #     else
  #       goto index
  #     end
  #   else
  #     flash fail
  #     go back to parent
  #   end
  # end
  def destroy
    get_evolutions
    if @object.destroy
      flash_success
      if @object_parent
        redirect_to @object_parent
      else
        redirect_to :action => "index"
      end
    else
      flash_fail
      redirect_to @object
    end
  end 

# pass1 = the evolution that will be re-assigned
# pass2 = the evolution that will remain un-changed


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
  def isolate_evolution(pass1)
    if pass1.evolution_id # if pass1 has parent
      pass1_parent = Evolution.find(pass1.evolution_id) # let pass1 parent be the pass1 parent
      attach_children_to pass1, pass1_parent # attach children of pass1 to pass1 parent
    else # pass1 is root
      for evolution in pass1.children
        evolution.evolution_id = nil
        evolution.save
      end
    end # end 
    pass1.evolution_id = nil
    pass1.save
  end






# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *get_evolutions 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def get_evolution_new
    @object_new = Evolution.new(:super_id => @object_super.id)
  end

  def get_evolution(pass=params[:id])
    @object_current = Evolution.find(pass) # get current
  end

  def get_evolutions(pass=params[:id])
    @object_current = Evolution.find(pass) # get current
    @object_root = @object.ancestors.last || @object_current # get root
    @object_super = @object_root #*** for testing then switch to feature id
    if @object.evolution_id
      @object_parent = Evolution.find(@object.evolution_id)
    end # get parent of current
    if session[:evolution_clone_id]
      @object_clone = Evolution.find(session[:evolution_clone_id]) 
    end # get clone_current from session
    if session[:evolution_clone_uni_id]
      @object_clone_uni = Evolution.find(session[:evolution_clone_uni_id]) 
    end # get clone_current_uni from session
    if session[:evolution_move_id]
      @object_move = Evolution.find(session[:evolution_move_id]) 
      if @object_current # if current
        check_for_childship @object_move, @object_current # check for childship
      end # end
    end # get move_current from session
    if session[:evolution_move_uni_id]
      @object_move_uni = Evolution.find(session[:evolution_move_uni_id]) 
      if @object_current # if current
        check_for_childship @object_move_uni, @object_current # check for childship
      end # end
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *agenda
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  # get the prioritized evolutions lists
  #   get evolutions
  #   get childless with root
  #   set prioritization with super
  #   redirect to action, agenda, id is evolution id
  # end
  def prioritize
    get_evolution 
    redirect_to :action => 'agenda', :id => @object.id
  end

  # [show] agenda
  #   get evolutions
  # end
  def agenda
    get_evolutions
  end










































end
