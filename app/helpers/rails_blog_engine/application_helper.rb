module RailsBlogEngine
  module ApplicationHelper
    def markdown(md_text)
      filtered = Filters.apply_all_to(md_text)
      sanitize(RDiscount.new(filtered, :smart).to_html)
    end
  end
end
