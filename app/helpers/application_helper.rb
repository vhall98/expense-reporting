module ApplicationHelper
  # # # DUMP
  # # # Dump an object out to a PP json string for debugging in templates
  def Dump(s)
    raw JSON.pretty_generate(JSON.parse(s.to_json.html_safe))
  end

end
