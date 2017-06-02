module ApplicationHelper

  def numbers_to_badges(coll)
    spans = coll.map do |x|
      "<span class=\"badge badge-pill badge-success\">#{x}</span>"
    end

    spans.join(" &nbsp; ")
  end

end
