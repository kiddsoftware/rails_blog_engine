module RailsBlogEngine
  class ApplicationController < ActionController::Base
    # Use our parent application's layout, so that we "auto-blend" into
    # the existing look-and-feel of the site.
    layout 'application'
  end
end
