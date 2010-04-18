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
    fetch_objects
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
    fetch_objects
    toggle_edit_logic @object
  end

  def update
    fetch_objects
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
    fetch_objects
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
    fetch_objects
    fetch_object_new
    place_at_root @object_new, @object_super
    save_new
  end
  def new_parent
    fetch_objects
    fetch_object_new
    place_at_parent @object_current, @object_new, @object_parent, @object_super
    save_new
  end
  def new_current
    fetch_objects
    fetch_object_new
    place_at_current @object_new
    save_new
  end
  def new_children
    fetch_objects
    fetch_object_new
    @object_new.save
    place_at_children @object_new
    save_new
  end
  def new_child
    fetch_objects
    fetch_object_new
    place_at_child @object_new
    save_new
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *set
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def set_clone
    fetch_objects
    session[:evolution_clone_id] = @object.id # set clone
    redirect_to @object_current # redirect to current
  end
  def set_clone_uni
    fetch_objects
    session[:evolution_clone_uni_id] = @object.id # set clone uni
    redirect_to @object_current # redirect to current
  end
  def set_move
    fetch_objects
    session[:evolution_move_id] = @object.id # set move
    redirect_to @object_current # redirect to current
  end
  def set_move_uni
    fetch_objects
    session[:evolution_move_uni_id] = @object.id # set move uni
    redirect_to @object_current # redirect to current
  end

  def move_to_move_uni
    fetch_objects
    session[:evolution_move_uni_id] = session[:evolution_move_id] # set uni to normal
    session[:evolution_move_id] = nil # nil normal
    redirect_to @object_current # redirect to current
  end
  def move_uni_to_move
    fetch_objects
    session[:evolution_move_id] = session[:evolution_move_uni_id] # set uni to normal
    session[:evolution_move_uni_id] = nil # nil normal
    redirect_to @object_current # redirect to current
  end
  
  def clone_to_clone_uni
    fetch_objects
    session[:evolution_clone_uni_id] = session[:evolution_clone_id] # set uni to normal
    session[:evolution_clone_id] = nil # nil normal
    redirect_to @object_current # redirect to current
  end
  def clone_uni_to_clone
    fetch_objects
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
    fetch_objects
    session[:evolution_clone_id]=nil # clear session
    redirect_to @object_current # redirect to current
  end
  def cancel_clone_uni
    fetch_objects
    session[:evolution_clone_uni_id]=nil # clear session
    redirect_to @object_current # redirect to current
  end
  def cancel_move
    fetch_objects
    session[:evolution_move_id]=nil # clear session
    redirect_to @object_current # redirect to current
  end
  def cancel_move_uni
    fetch_objects
    session[:evolution_move_uni_id]=nil # clear session
    redirect_to @object_current # redirect to current
  end

  def destroy
    fetch_objects
    if @object_current.destroy
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

  def agenda
    fetch_objects
  end










































end
