# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'development'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.i18n.default_locale = :fr

  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.log_level = :debug

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem "mysql"
  config.gem "memcache-client", :lib => "memcache"
  config.gem "ruby-openid", :lib => "openid"
  config.gem "chronic"
  config.gem "rmagick"

  config.active_record.observers = :user_observer,
                                   :post_observer,
                                   :topic_observer

  # config.active_record.schema_format = :sql
  # config.active_record.default_timezone = :utc
  if defined?(Memcache)
    config.cache_store = :mem_cache_store, 'localhost', { :namespace => "wefrag" }
  end
end

WillPaginate::ViewHelpers.pagination_options[:prev_label] = '&laquo;'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '&raquo;'

WhiteListHelper.tags.merge %w(u)

ExceptionNotifier.exception_recipients = 'ced@wal.fr'

