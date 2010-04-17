# Methods added to this logic will be available to all templates in the application---priority logic home
module PriorityLogic


# ********* ********* ********* ********* ********* ********* ********* ********* *********
#
# *pioritizing
#
# ********* ********* ********* ********* ********* ********* ********* ********* *********

  # get prioritization with super id
  #   get super id
  #   pre prioritizations are objects with super id and ascending ancestorizations
  #   set prioritization with ready_to_prioritize
  # end
  # from root to tips
  def get_prioritization(one)
    seek_ends one.root||one
    end_ones = one.class.find(:all, :conditions => { 
      :childless => true, 
      :super_id => one.super_id }, 
      :order => "ancestorization ASC" )
    end_ones.each do |end_one|
      set_prioritization end_one
    end
  end

  # locate and get childless objects of passed object
  #   set childless status with pass
  #   set ancestorization with one
  #   set super with one
  #   if one not childless, then
  #     for each child
  #       loop passing child
  #     end
  #   end
  # end
  def seek_ends(one)
    check_super one
    check_childless_status one 
    count_ancestors one
    if !one.children.empty? 
      for child in one.children		 
        seek_ends child
      end
    end 
  end 

  def check_super(one)
    one.super_id = one.root.super_id
    one.save
  end

  # set childless state of passed object
  #   if childless, then
  #     childless is true
  #   else, not childless, so
  #     childless is false
  #   end
  #   save
  # end
  def check_childless_status(one)
    if one.children.empty? 	
      one.childless = true 	
    else 			
      one.childless = false 	
    end 		
    one.save 		
  end 	

  # set ancestorization with passed object
  #   one ancestorization is ancestor size
  #   save
  # end
  def count_ancestors(one)
    one.ancestorization = one.ancestors.size 
    one.save 
  end

  # set prioritization with one
  #   counter equals one
  #   prioritization equals counter
  #   save
  #   for each ancestor
  #     advance counter
  #     pioritization equals counter
  #     save
  #   end
  # end
  def set_prioritization(one)
    counter = 1
    one.prioritization = counter
    one.save
    one.ancestors.each do |ancestor|
      counter = counter + 1
      ancestor.prioritization = counter
      ancestor.save
    end
  end

  # duplicate object attributes
  #   two equals one
  # end
  def copy_over(one, two)
    two.header = one.header
    two.detail = one.detail
    two.save
  end

end
