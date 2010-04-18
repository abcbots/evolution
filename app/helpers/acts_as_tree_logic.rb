# Methods added to this module will be available to all templates in the application---expanding acts_as_tree logic
module ActsAsTreeLogic

 
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *attach_to
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def attach_to(object_from, object_to)
    if object_from.class == object_to.class
      object_from.super_id = object_to.super_id
      object_from.parent_id = object_to.id
    else
      object_from.super_id = object_to.id
      object_from.parent_id = nil 
    end
    object_from.save
  end

  def attach_children_to(object_from, object_to)
    object_from.children.each do |child| { attach_to child, object_to } end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *clone
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def make_clone(active_object)
    @new_object = active_object.dup
    @new_object.save
    clone_children_to active_object, @new_object
  end
  def clone_children_to(active_object, new_object)
    active_object.children.each do |active_object_child|
      new_object_child = active_object_child.dup
      new_object_child.save
      attach_to new_object_child, new_object
      clone_children_to active_object_child, new_object_child
    end
  end
  #  hhhhhheeeeeerrrrrrrrrdhere!!!
  def make_clone_uni
    fetch_objects
    duplicate_object
    copy_over evolution_clone_uni, @clone_object_uni
    @clone_object_uni = evolution_clone_uni
  end
  def clone_object(active_object)
    @new_object = active_object.dup
  end

  def clone_to_root
    make_clone @clone_object
    place_at_root @new_object, @object_super
    save_clone
  end
  def clone_to_parent
    make_clone
    place_at_parent @clone_object, @object_current
    save_clone
  end
  def clone_to_current
    make_clone
    place_at_current @clone_object
    save_clone
  end
  def clone_to_children
    make_clone
    place_at_children @clone_object
    save_clone
  end
  def clone_to_child
    make_clone
    place_at_child @clone_object
    save_clone
  end
  
  def clone_uni_to_root
    make_clone_uni
    place_at_root @clone_object_uni, @object_super
    save_clone_uni
  end
  def clone_uni_to_parent
    make_clone_uni
    place_at_parent @clone_object_uni, @object_current
    save_clone_uni
  end
  def clone_uni_to_current
    make_clone_uni
    isolate_evolution @object_move_uni
    place_at_current @object_move_uni
    save_move_uni
  end
  def move_uni_to_child
    fetch_objects
    isolate_evolution @object_move_uni
    place_at_child @object_move_uni
    save_move_uni
  end
  def move_uni_to_children
    fetch_objects
    isolate_evolution @object_move_uni
    place_at_children @object_move_uni
    save_move_uni
  end
  def clone_uni_to_children
    make_clone_uni
    place_at_children @clone_object_uni
    save_clone_uni
  end
  def clone_uni_to_child
    make_clone
    place_at_child @clone_object_uni
    save_clone
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *fetch_objects 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def fetch_new_object(object_current=@object_current)
    @new_object = object_current.class.new(:super_id => object_current.super_id)
  end

  def fetch_objects(object_params_id=params[:id], object_class, object_super_class)
    @object_current = object_class.find(object_params_id)
    @object_root = @object_current.ancestors.last || @object_current
    @object_super = object_super_class.find_by_super_id(@object_current.super_id)
    if @object_current.parent_id
      @object_parent = @object_current.class.find_by_parent_id(@object_current.parent_id)
    end
    if @object_current.class == Evolution
      fetch_evolutions
    elsif @object_current.class == Mutation
      fetch_mutations
    end
  end

  def fetch_evolutions
    if session[:evolution_clone_id]
      @clone_object = Evolution.find(session[:evolution_clone_id]) 
    end
    if session[:evolution_clone_uni_id]
      @clone_object_uni = Evolution.find(session[:evolution_clone_uni_id]) 
    end
    if session[:evolution_move_id]
      @move_object = Evolution.find(session[:evolution_move_id]) 
      if @object_current
        check_for_childship @move_object, @object_current
      end
    end
    if session[:evolution_move_uni_id]
      @move_object_uni = Evolution.find(session[:evolution_move_uni_id]) 
      if @object_current
        check_for_childship @move_object_uni, @object_current 
      end
    end
  end

  def fetch_mutations
    if session[:mutation_clone_id]
      @clone_object = Mutatiion.find(session[:mutation_clone_id]) 
    end
    if session[:mutation_clone_uni_id]
      @clone_object_uni = Mutatiion.find(session[:mutation_clone_uni_id]) 
    end
    if session[:mutation_move_id]
      @move_object = Mutatiion.find(session[:mutation_move_id]) 
      if @object_current
        check_for_childship @move_object, @object_current
      end
    end
    if session[:mutation_move_uni_id]
      @move_object_uni = Mutatiion.find(session[:mutation_move_uni_id]) 
      if @object_current
        check_for_childship @move_object_uni, @object_current 
      end
    end
  end

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *isolate 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def isolate_object(active_object)
    if active_object.parent_id
      active_object_parent = active_object.class.find_by_parent_id(active_object.parent_id)
      attach_children_to active_object, active_object_parent
    elsif active_object.super_id
      active_object_super = active_object.class.find_by_super_id(active_object.super_id)
      attach_children_to active_object, active_object_super
    end
    active_object.super_id = nil
    active_object.parent_id = nil
    active_object.save
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *move
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def check_for_childship(active_object, object_test)
    if active_object == object_test
      @childship = true
    else
      check_for_childship_children active_object, object_test
    end
  end
  def check_for_childship_children(active_object, object_test)
    active_object.children.each do |child|
      if child == object_test
        @childship = true
      end
      check_for_childship_children child, object_test
    end
  end
    
  def move_to_root
    fetch_objects
    place_at_root @move_object, @object_current
    save_move
  end
  def move_to_parent
    fetch_objects
    place_at_parent @move_object, @object_current
    save_move
  end
  def move_to_current
    fetch_objects
    place_at_current @move_object
    save_move
  end
  def move_to_children
    fetch_objects
    place_at_children @move_object, @object_current
    save_move
  end
  def move_to_child
    fetch_objects
    place_at_child @move_object, @object_current
    save_move
  end

  def move_uni_to_root
    fetch_objects
    isolate_object @move_object_uni
    place_at_root @move_object_uni, @object_current
    save_move_uni
  end
  def move_uni_to_parent
    fetch_objects
    isolate_object @move_object_uni
    place_at_parent @move_object_uni, @object_current
    save_move_uni
  end
  def move_uni_to_current
    fetch_objects
    isolate_object @move_object_uni
    place_at_current @move_object_uni
    save_move_uni
  end
  def move_uni_to_child
    fetch_objects
    isolate_object @move_object_uni
    place_at_child @move_object_uni, @object_current
    save_move_uni
  end
  def move_uni_to_children
    fetch_objects
    isolate_object @move_object_uni
    place_at_children @move_object_uni, @object_current
    save_move_uni
  end


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *place_at
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def place_at_root(active_object, object_current)
    if active_object.class == object_current.class
      active_object.super_id = object_current.super_id
      active_object.parent_id = nil
      active_object.save
    end
  end

  def place_at_parent(active_object, object_current)
    if active_object.class == object_current.class
      if object_current.parent_id
        active_object.super_id = object_current.super_id
        active_object.parent_id = object_current.parent_id
      else
        active_object.super_id = object_current.super_id
        active_object.parent_id = nil
      end
      active_object.save
    end
  end

  def place_at_current(active_object, object_current)
    if active_object.class == object_current.class
      active_object.super_id = object_current.super_id
      active_object.parent_id = object_current.parent_id
      active_object.save
    end
  end

  def place_at_children(active_object, object_current)
    if active_object.class == object_current.class
      move_children_to active_current, object_active
      place_at_child active_object, object_current
      active_object.save
    end
  end

  def place_at_child(active_object, current_object)
    if active_object.class == object_current.class
      active_object.parent_id = current_object.id
      active_object.super_id = current_object.super_id
      active_object.save
    end
  end

  def move_children_to(active_object, object_to)
    active_object.children.each do |child|
      attach_to child, object_to
    end
  end




end
