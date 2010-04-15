# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

#******************************
# toggle_div to toggle text
#******************************

# *toggle

  # TOGGLE DIV
  def toggle_div(link_text, div_id)
    html = nil
    html = link_to_function link_text, "Effect.toggle('#{div_id}_#{link_text}')"
    return html
  end
  # TOGGLE DIV ID---JUST ADD </DIV> AT END
  def toggle_div_id(link_text, div_id)
    html = nil
    html = "<div id=\"#{div_id}_#{link_text}\", style=\"display:none;\">"
    return html
  end

# *check_for_childship

  def check_for_childship(pass1, pass2) # get to_be_checked and to_check_from
    result = false # result starts out at false
    if pass1 == pass2 # if to-be-checked is equal to to_check_from
      result = true # return true
    elsif pass1.children.exists? # else if to-be-checked has children
      check_for_childship_children pass1, pass2 # send to children checker...
    end # end
    return result
  end
  def check_for_childship_children(pass1, pass2) # check if child of check_from
    pass1.children.each do |child| # for children of to be checked, get child
      if pass1 == child # if to be checked is equal to child
        result = true # result equals true
      elsif pass1.children.exists? # else, if there are more children
        check_for_childship_children child, pass1 # loop
      end # end
      return result # return result
    end # end
  end # end

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

end
