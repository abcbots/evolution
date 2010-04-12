class EvolutionsController < ApplicationController

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *basics
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def index
    @evolutions = Evolution.all
  end
  
  def show
    get_evolutions
  end
   
  def new
    @evolution = Evolution.new
    if @evolution.save
      flash_success   
      redirect_to @evolution
    else
      flash_fail  
      redirect_to evolutions_path
    end
  end
  
  def create
    @evolution = Evolution.new(params[:evolution])
    if @evolution.save
      flash[:notice] = "Successfully created evolution."
      redirect_to @evolution
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
    if session[:edit] == true
      session[:edit] = false
    else
      session[:edit] = true 
    end
    redirect_to @evolution
  end

  def update
    @evolution = Evolution.find(params[:id])
    if @evolution.update_attributes(params[:evolution])
      flash_success
      session[:edit] = false
      redirect_to @evolution
    else
      flash_fail
      redirect_to @evolution
    end
  end
  
  def destroy
    get_evolutions
    @evolution.destroy
    flash_success
    redirect_to @evolution_parent||evolutions_path
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *save 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def save_new
    if @evolution_new.save
      flash_success
      redirect_to @evolution_new
    else
      flash_fail
      redirect_to @evolution
    end
  end

  def save_clone
    if @evolution_clone.save
      flash_success
      session[:evolution_clone_id] = nil
      redirect_to @evolution_clone
    else
      flash_fail
      redirect_to @evolution
    end
  end
  def save_clone_uni
    if @evolution_clone_uni.save
      flash_success
      session[:evolution_clone_uni_id] = nil
      redirect_to @evolution_clone_uni
    else
      flash_fail
      redirect_to @evolution
    end
  end

  def save_move
    if @evolution_move.save
      flash_success
      session[:evolution_move_id] = nil
      redirect_to @evolution_move
    else
      flash_fail
      redirect_to @evolution
    end
  end
  def save_move_uni
    if @evolution_move_uni.save
      flash_success
      session[:evolution_move_uni_id] = nil
      redirect_to @evolution_move_uni
    else
      flash_fail
      redirect_to @evolution
    end
  end
  

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *new
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def new_root
    get_evolutions
    @evolution_new = Evolution.new
    place_at_root @evolution_new
    save_new
  end
  def new_parent
    get_evolutions
    @evolution_new = Evolution.new
    place_at_parent @evolution_new
    save_new
  end
  def new_current
    get_evolutions
    @evolution_new = Evolution.new
    place_at_current @evolution_new
    save_new
  end
  def new_children
    get_evolutions
    @evolution_new = Evolution.new
    @evolution_new.save
    place_at_children @evolution_new
    save_new
  end
  def new_child
    get_evolutions
    @evolution_new = Evolution.new
    place_at_child @evolution_new
    save_new
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *set
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def set_clone
    get_evolutions
    session[:evolution_clone_id] = @evolution.id # set clone
    redirect_to @evolution # redirect to current
  end
  def set_clone_uni
    get_evolutions
    session[:evolution_clone_uni_id] = @evolution.id # set clone uni
    redirect_to @evolution # redirect to current
  end
  def set_move
    get_evolutions
    session[:evolution_move_id] = @evolution.id # set move
    redirect_to @evolution # redirect to current
  end
  def set_move_uni
    get_evolutions
    session[:evolution_move_uni_id] = @evolution.id # set move uni
    redirect_to @evolution # redirect to current
  end

  def move_to_move_uni
    get_evolutions
    session[:evolution_move_uni_id] = session[:evolution_move_id] # set uni to normal
    session[:evolution_move_id] = nil # nil normal
    redirect_to @evolution # redirect to current
  end
  def move_uni_to_move
    get_evolutions
    session[:evolution_move_id] = session[:evolution_move_uni_id] # set uni to normal
    session[:evolution_move_uni_id] = nil # nil normal
    redirect_to @evolution # redirect to current
  end
  
  def clone_to_clone_uni
    get_evolutions
    session[:evolution_clone_uni_id] = session[:evolution_clone_id] # set uni to normal
    session[:evolution_clone_id] = nil # nil normal
    redirect_to @evolution # redirect to current
  end
  def clone_uni_to_clone
    get_evolutions
    session[:evolution_clone_id] = session[:evolution_clone_uni_id] # set uni to normal
    session[:evolution_clone_uni_id] = nil # nil normal
    redirect_to @evolution # redirect to current
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *cancel
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def cancel_clone
    get_evolutions
    session[:evolution_clone_id]=nil # clear session
    redirect_to @evolution # redirect to current
  end
  def cancel_clone_uni
    get_evolutions
    session[:evolution_clone_uni_id]=nil # clear session
    redirect_to @evolution # redirect to current
  end
  def cancel_move
    get_evolutions
    session[:evolution_move_id]=nil # clear session
    redirect_to @evolution # redirect to current
  end
  def cancel_move_uni
    get_evolutions
    session[:evolution_move_uni_id]=nil # clear session
    redirect_to @evolution # redirect to current
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
    copy_over @evolution_clone, evolution_new
    clone_children @evolution_clone, evolution_new
    @evolution_clone = evolution_new
  end
  def make_clone_uni
    get_evolutions
    evolution_clone_uni = Evolution.new
    copy_over evolution_clone_uni, @evolution_clone_uni
    @evolution_clone_uni = evolution_clone_uni
  end

  def clone_to_root
    make_clone
    place_at_root @evolution_clone
    save_clone
  end
  def clone_to_parent
    make_clone
    place_at_parent @evolution_clone
    save_clone
  end
  def clone_to_current
    make_clone
    place_at_current @evolution_clone
    save_clone
  end
  def clone_to_children
    make_clone
    place_at_children @evolution_clone
    save_clone
  end
  def clone_to_child
    make_clone
    place_at_child @evolution_clone
    save_clone
  end
  
  def clone_uni_to_root
    make_clone_uni
    place_at_root @evolution_clone_uni
    save_clone_uni
  end
  def clone_uni_to_parent
    make_clone_uni
    place_at_parent @evolution_clone_uni
    save_clone_uni
  end
  def clone_uni_to_current
    make_clone_uni
    isolate_evolution @evolution_move_uni
    place_at_current @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_evolutions
    isolate_evolution @evolution_move_uni
    place_at_child @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_children
    get_evolutions
    isolate_evolution @evolution_move_uni
    place_at_children @evolution_move_uni
    save_move_uni
  end
  def clone_uni_to_children
    make_clone_uni
    place_at_children @evolution_clone_uni
    save_clone_uni
  end
  def clone_uni_to_child
    make_clone
    place_at_child @evolution_clone_uni
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
    place_at_root @evolution_move
    save_move
  end
  def move_to_parent
    get_evolutions
    place_at_parent @evolution_move
    save_move
  end
  def move_to_current
    get_evolutions
    place_at_current @evolution_move
    save_move
  end
  def move_to_children
    get_evolutions
    place_at_children @evolution_move
    save_move
  end
  def move_to_child
    get_evolutions # get evolutions
    place_at_child @evolution_move # place move at child position
    save_move # save move
  end

  def move_children_to(pass)
    @evolution.children.each do |child| # for children
      attach_to child, pass # attach child to pass
    end # end
  end

  def move_uni_to_root
    get_evolutions
    isolate_evolution @evolution_move_uni
    place_at_root @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_parent
    get_evolutions
    isolate_evolution @evolution_move_uni
    place_at_parent @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_current
    get_evolutions
    isolate_evolution @evolution_move_uni
    place_at_current @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_evolutions
    isolate_evolution @evolution_move_uni
    place_at_child @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_children
    get_evolutions
    isolate_evolution @evolution_move_uni
    place_at_children @evolution_move_uni
    save_move_uni
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *destroy
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def destroy
    get_evolutions
    if @evolution.destroy
      flash_success
      if @evolution_parent
        redirect_to @evolution_parent
      else
        redirect_to :action => "index"
      end
    else
      flash_fail
      redirect_to @evolution
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
# *place 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def place_at_root(pass)
    pass.super_id = @evolution_super.id
    pass.evolution_id = nil
    pass.save
  end
  def place_at_parent(pass)
    pass.super_id = @evolution_super.id
    if @evolution_parent # if parent
      attach_to pass, @evolution_parent # attach pass to parent
      pass.save # save pass
    else # else, root
      pass.evolution_id = nil # erase parent
      pass.save # save pass
    end # end
    attach_to @evolution, pass # attach evolution to pass
    @evolution.save # save evolution to new parent
  end
  def place_at_current(pass)
    pass.super_id = @evolution_super.id
    if @evolution_parent # if parent 
      attach_to pass, @evolution_parent # attach pass to parent
    else # else, is root
      pass.evolution_id = nil # erase parent
    end # end 
    pass.save # save pass
  end
  def place_at_child(pass)
    pass.super_id = @evolution_super.id
    attach_to pass, @evolution
    pass.save
  end
  def place_at_children(pass)
    pass.super_id = @evolution_super.id
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
      pass1.evolution_id = nil
      pass1.evolution_id = pass2.id
      pass1.save
    else # pass2 is parent
      pass1.evolution_id = pass2.id
      #pass1.evolution_id = nil
      pass1.save
    end
  end
  def attach_children_to(pass1, pass2)
    for evolution in pass1.children # attach children to pass
      attach_to evolution, pass2 
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
    @evolution = Evolution.find(params[:id])
    @evolution.start_time = Time.now
    if @evolution.save
      flash[:notice] = "Successfully started evolution(#{@evolution.id}) at #{@evolution.start_time}"
      redirect_to @evolution
    else
      flash[:error] = "Sorry, try again."
      redirect_to @evolution
    end
  end 

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *get_evolutions 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def get_evolution(pass=params[:id])
    @evolution = Evolution.find(pass) # get current
  end
  def get_evolutions(pass=params[:id])
    @evolution = Evolution.find(pass) # get current
    @evolution_root = @evolution.ancestors.last || @evolution # get root
    @evolution_super = @evolution_root #*** for testing then switch to feature id
    if @evolution.evolution_id
      @evolution_parent = Evolution.find(@evolution.evolution_id)
    end # get parent of current
    if session[:evolution_clone_id]
      @evolution_clone = Evolution.find(session[:evolution_clone_id]) 
    end # get clone_current from session
    if session[:evolution_clone_uni_id]
      @evolution_clone_uni = Evolution.find(session[:evolution_clone_uni_id]) 
    end # get clone_current_uni from session
    if session[:evolution_move_id]
      @evolution_move = Evolution.find(session[:evolution_move_id]) 
      if @evolution # if current
        check_for_childship @evolution_move, @evolution # check for childship
      end # end
    end # get move_current from session
    if session[:evolution_move_uni_id]
      @evolution_move_uni = Evolution.find(session[:evolution_move_uni_id]) 
      if @evolution # if current
        check_for_childship @evolution_move_uni, @evolution # check for childship
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
  #   refresh agenda
  #   redirect to action, agenda, id is evolution id
  # end
  def get_agenda
    get_evolutions 
    get_childless @evolution_root, @evolution_super
    get_prioritization @evolution_super
    redirect_to :action => 'agenda', :id => @evolution.id
  end

  # get prioritization with super id
  #   get super id
  #   pre prioritizations are objects with super id and ascending ancestorizations
  #   set prioritization with ready_to_prioritize
  # end
  def get_prioritization(pass)
    pass1 = pass 
    evolutions = Evolution.find(:all, :conditions => {:childless => true, :super_id => pass1.id}, :order => "ancestorization ASC" )
    for evolution in evolutions 
      set_prioritization evolution 
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
  #   get evolutions
  #   evolutions equals all of same super, in order of prioritization, ascending
  #   prioritization max equals max prioritization of same super
  # end
  def agenda
    get_evolutions
    @evolutions = Evolution.find(:all, :conditions => {:super_id => @evolution_super.id}, :order => "prioritization ASC" )
    @prioritization_max = Evolution.maximum(:prioritization, :conditions => {:super_id => @evolution_super.id} )
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
  def get_childless(pass, pass_super) 
    set_childless_status pass
    set_ancestorization pass
    set_super pass, pass_super
    if !pass.children.empty? 
      for child in pass.children
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
    pass.ancestorization = pass.ancestors.size 
    pass.save 
  end

  # set super with pass and pass super
  #   get pass
  #   pass super is current super
  #   save
  # end
  def set_super(pass, pass_super)
    pass.super_id = pass_super.id
    pass.save
  end











































end
