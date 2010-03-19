class EvolutionsController < ApplicationController

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# Evolution: Tree | New | Clone | Move | Destroy # layouts/evolutions/menu
#
# New: Root | Parent | Current | Child # layouts/mutatons/new
# Clone Current: Complete | One # layouts/evolutions/clone
# Move Current: Complete | One # layouts/evolutions/move
# Destroy Current: Complete | One # layouts/evolutions/destroy
#
# Clone to: Root | Parent | Current | Child | Cancel # layouts/evolutions/clone_to
# Clone uni to: Root | Parent | Current | Child | Cancel # layouts/evolutions/clone_uni_to
# Move to: Root | Parent | Current | Child | Cancel # layouts/evolutions/move_to
# Move uni to: Root | Parent | Current | Child | Cancel # layouts/evolutions/move_uni_to
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 basics
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def index
    @evolutions = Evolution.all
  end
  
  def show
    get_evolutions
  end
   
  def new
    @no_links = true
    @evolution = Evolution.new
    @evolution.evolution_id = params[:evolution_id]
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
  
  def edit
    @evolution = Evolution.find(params[:id])
  end
  
  def update
    @evolution = Evolution.find(params[:id])
    if @evolution.update_attributes(params[:evolution])
      flash[:notice] = "Successfully updated evolution."
      redirect_to @evolution
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @evolution = Evolution.find(params[:id])
    @evolution.destroy
    flash[:notice] = "Successfully destroyed evolution."
    redirect_to evolutions_url
  end




# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   save 
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
#                                   new
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
  def new_child
    get_evolutions
    @evolution_new = Evolution.new
    place_at_child @evolution_new
    save_new
  end
  def new_children
    get_evolutions
    @evolution_new = Evolution.new
    place_at_children @evolution_new
    save_new
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   set
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

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  cancel
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
#                                  clone
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def copy_over_to_from(subject_to, object_from)
    #copy script
  end
  def clone_children_to_from(subject_to, object_from)
    for evolution in object_from.children
      evolution_clone = Evolution.new
      copy_over_to_from evolution_clone, evolution
      evolution_clone.save
      clone_children_to_from evolution_clone, evolution
    end
  end

  def make_clone
    get_evolutions
    evolution_clone = Evolution.new
    copy_over_to_from evolution_clone, @evolution_clone
    evolution_clone.save
    clone_children_to_from evolution_clone, @evolution_clone
    @evolution_clone = evolution_clone
  end
  def make_clone_uni
    get_evolutions
    evolution_clone_uni = Evolution.new
    copy_over_to_from evolution_clone_uni, @evolution_clone_uni
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
  def clone_to_child
    make_clone
    place_at_child @evolution_clone
    save_clone
  end
  def clone_to_children
    make_clone
    place_at_children @evolution_clone
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
    place_at_current @evolution_clone_uni
    save_clone_uni
  end
  def clone_to_child
    make_clone
    place_at_child @evolution_clone
    save_clone
  end
  def clone_uni_to_children
    make_clone_uni
    place_at_children @evolution_clone_uni
    save_clone_uni
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                   move
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

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
  def move_to_child
    get_evolutions
    place_at_child @evolution_move
    save_move
  end
  def move_to_children
    get_evolutions
    place_at_children @evolution_move
    save_move
  end

  def move_uni_to_root
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_root @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_parent
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_parent @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_current
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_current @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_child
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_child @evolution_move_uni
    save_move_uni
  end
  def move_uni_to_children
    get_evolutions
    distill_evolution @evolution_move_uni
    place_at_children @evolution_move_uni
    save_move_uni
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 destroy
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def destroy_current
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
  def destroy_current_uni
    get_evolutions
    distill_evolution @evolution
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

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 place_at 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def place_at_root(subject)
    #subject.evolution_id = @evolution_root.evolution_id
    subject.evolution_id = nil
    subject.save
  end
  def place_at_parent(subject)
    if @evolution_parent # if parent
      attach_to subject, @evolution_parent # attach subject to parent
      subject.save # save subject
    else # else, root
      subject.evolution_id = nil # erase parent
      subject.save # save subject
    end # end
    attach_to @evolution, subject # attach evolution to subject
    @evolution.save # save evolution to new parent
  end
  def place_at_current(subject)
    if @evolution_parent # if parent 
      attach_to subject, @evolution_parent
    end
    subject.save
  end
  def place_at_child(subject)
    attach_to subject, @evolution
    subject.save
  end
  def place_at_children(subject)
    attach_children_to @evolution, subject
    attach_to subject, @evolution
    subject.save
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                              get_evolutions 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 


# get_evolutions
## @evolution_super(if exists)
# @evolution_root
# @evolution_parent(if exists)
# @evolution
# @evolution_move(if exists)
# @evolution_move_uni(if exists)
# @evolution_clone(if exists)
# @evolution_clone_uni(if exists)

  def get_evolutions(pass=params[:id])
    @evolution = Evolution.find(pass) # get current
    @evolution_root = @evolution.ancestors.last # get root
    #if @evolution.evolution_id
      #@evolution_super = Evolution.find(@evolution.evolution_id)
    #end # get super of current
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
    end # get move_current from session
    if session[:evolution_move_uni_id]
      @evolution_move_uni = Evolution.find(session[:evolution_move_uni_id]) 
    end
  end

# subject = the evolution that will be re-assigned
# object = the evolution that will remain un-changed
# whole = indicates if the subject includes all children

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                 distill 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def distill_evolution(subject)
    if subject.evolution_id # if subject has parent
      subject_parent = Evolution.find(subject.evolution_id)
      attach_children_to subject, subject_parent
    else # subject has super
      subject_super = Evolution.find(subject.evolution_id)
      attach_children_to subject, subject_super, true
    end
    subject.evolution_id = subject.evolution_id = nil
    subject.save
  end
  
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
#                                  attach 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def attach_to(subject, object, object_is_super=false)
    if object_is_super
      subject.evolution_id = nil
      subject.evolution_id = object.id
      subject.save
    else # object is parent
      subject.evolution_id = object.id
      #subject.evolution_id = nil
      subject.save
    end
  end

  def attach_children_to(subject, object, object_is_super=false)
    if object_is_super
      for evolution in subject.children
        attach_to evolution, object, object_is_super
      end
    else # object is parent
      for evolution in subject.children
        attach_to evolution, object 
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


end
