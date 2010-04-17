# Methods added to this module will be available to all templates in the application---expanding acts_as_tree logic
module ActsAsTreeLogic

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *place 
#
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

  def place_at_root(object_active, object_super)
    attach_to object_active, object_super
  end

  def place_at_parent(object_current, object_active, object_parent=nil, object_super)
    object_active.super_id = object_parent.super_id||object_super.id
    if object_parent
      attach_to object_active, object_parent
    else 
      if object_active.parent_id { object_active.parent_id = nil }
      if object_active.evolution_id { object_active.evolution_id = nil }
    end
    object_active.save
    attach_to object_current, object_active
    object_current.save
  end


#********dddadafadkfldflkadjfldflkdlfksadlfkjdlkjladflkjadflkdjflkjadlkfmarker
  def place_at_current(object_active, object_parent=nil, object_super)
    object_active.super_id = object_super.id
    if object_parent  
      attach_to object_active, object_parent
    else 
      object_active.evolution_id = nil # erase parent
    end # end 
    object_active.save # save object_active
  end

  def place_at_child(pass)
    pass.super_id = @object_super.id
    attach_to pass, @object
    pass.save
  end

  def place_at_children(pass)
    pass.super_id = @object_super.id
    move_children_to pass
    place_at_child pass
    pass.save
  end


 
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
#
# *attach 
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




end
