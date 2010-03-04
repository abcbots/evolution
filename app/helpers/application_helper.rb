# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

#******************************
# toggle_div to toggle text
#******************************
  # TOGGLE DIV
  def toggle_div(link_text, div_id)
    link_to_function link_text, "Effect.toggle('#{div_id}_#{link_text}')"
  end

  # TOGGLE DIV ID---JUST ADD </DIV> AT END
  def toggle_div_id(link_text, div_id)
    html = "<div id=\"#{div_id}_#{link_text}\", style=\"display:none;\">"
    return html
  end

end
