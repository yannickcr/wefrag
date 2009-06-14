OPEN_ID_SECRET = "<%= ActiveSupport::SecureRandom.hex(64) %>"
ActionController::Base.session = { :secret => "<%= ActiveSupport::SecureRandom.hex(64) %>" }

