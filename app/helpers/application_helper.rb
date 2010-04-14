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


# ********* ********* ********* ********* ********* ********* ********* ********* *********
# *pioritizing
# ********* ********* ********* ********* ********* ********* ********* ********* *********

  # get prioritization with super id
  #   get super id
  #   pre prioritizations are objects with super id and ascending ancestorizations
  #   set prioritization with ready_to_prioritize
  # end
  def get_prioritization(thing_one)
    set_childless thing_one
    childless_thing_ones = thing_one.class.find(:all, :conditions => {
      :childless => true, 
      :super_id => thing_one.super_id }, 
      :order => "ancestorization ASC" )
    childless_thing_ones.each do |childless_thing_one|
      set_prioritization childless_thing_one
    end
  end

  # set prioritization with thing_one
  #   counter equals thing_one
  #   prioritization equals counter
  #   save
  #   for each ancestor
  #     advance counter
  #     pioritization equals counter
  #     save
  #   end
  # end
  def set_prioritization(childless_thing_one)
    counter = 1
    childless_thing_one.prioritization = counter
    childless_thing_one.save
    childless_thing_one.ancestors.each do |ancestor|
      counter = counter + 1
      ancestor.prioritization = counter
      ancestor.save
    end
  end

  # locate and get childless objects of passed object
  #   set childless status with pass
  #   set ancestorization with thing_one
  #   set super with thing_one
  #   if thing_one not childless, then
  #     for each child
  #       loop passing child
  #     end
  #   end
  # end
  def set_childless(thing_one) 
    check_childless_status thing_one 
    set_ancestorization thing_one
    if !thing_one.children.empty? 
      for child in thing_one.children		 
        set_childless child
      end
    end 
  end 

  # set childless state of passed object
  #   if childless, then
  #     childless is true
  #   else, not childless, so
  #     childless is false
  #   end
  #   save
  # end
  def check_childless_status(thing_one)
    if thing_one.children.empty? 	
      thing_one.childless = true 	
    else 			
      thing_one.childless = false 	
    end 		
    thing_one.save 		
  end 	

  # set ancestorization with passed object
  #   thing_one ancestorization is ancestor size
  #   save
  # end
  def set_ancestorization(thing_one)
    thing_one.ancestorization = thing_one.ancestors.size 
    thing_one.save 
  end


end
