OPEN_ID_SECRET = "<%= ActiveSupport::SecureRandom.hex(64) %>"

ActionController::Base.session = { :secret => "<%= ActiveSupport::SecureRandom.hex(64) %>" }
ActionController::Base.cache_store = :mem_cache_store, 'localhost', { :namespace => "wefrag" }

