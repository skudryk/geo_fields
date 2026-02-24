class ApplicationController < ActionController::Base
  allow_browser versions: :modern, unless: -> { request.format.json? }

  # JSON requests are authenticated via X-Client-Id / X-Client-Secret headers
  protect_from_forgery unless: -> { request.format.json? }
end
