module ApplicationHelper

  def game_name
    name = "Dawn of Ninjas"
    name
  end
  
  def wrap_text(txt)
    if txt.length > 80
      txt.gsub(/(.{1,60})( +|$\n?)|(.{1,60})/,
        "   \\1\\3\n")
    else
      txt
    end
  end
end
