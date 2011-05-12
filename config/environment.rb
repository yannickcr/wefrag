# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.3.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

if Gem::VERSION >= "1.3.6" 
  module Rails
    class GemDependency
      def requirement
        r = super
        (r == Gem::Requirement.default) ? nil : r
      end
    end
  end
end

Rails::Initializer.run do |config|

  config.i18n.default_locale = :fr

  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.log_level = :debug

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem "memcache-client", :lib => "memcache"
  config.gem "ruby-openid", :lib => "openid"
  config.gem "chronic"
  config.gem "rmagick", :lib => "RMagick"

  config.active_record.observers = :user_observer,
                                   'user/password_reset_observer',
                                   :post_observer,
                                   :topic_observer

  # config.active_record.schema_format = :sql
  # config.active_record.default_timezone = :utc
  config.cache_store = :mem_cache_store, 'localhost', { :namespace => "wefrag/#{RAILS_ENV}" }
end


WhiteListHelper.tags.merge %w(u)
ExceptionNotifier.exception_recipients = 'ced@wal.fr'

