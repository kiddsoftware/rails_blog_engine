module RailsBlogEngine
  module ApplicationHelper
    def markdown(md_text)
      sanitize(RDiscount.new(md_text, :smart).to_html)
    end
  end
end
