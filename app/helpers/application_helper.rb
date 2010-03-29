# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

#******************************
# toggle_div to toggle text
#******************************

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
  end

end
