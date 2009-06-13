config.cache_classes = true
config.log_level     = :warn

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

config.action_controller.asset_host = 'medias.wefrag.com'

config.action_mailer.delivery_method       = :sendmail
config.action_mailer.raise_delivery_errors = false

config.cache_store = :mem_cache_with_local_store, APP_CONFIG['memcache']['server'], { :namespace => APP_CONFIG['memcache']['namespace'] }
