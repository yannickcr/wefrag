module ActiveSupport
  module Cache
    class MemCacheStore < Store
      def read(key, options = nil)
        Rails.logger.info "LOAD"
        autoload_missing_constants do
          super(key, options)
        end
      end

      protected

      def autoload_missing_constants
        yield
      rescue ArgumentError, MemCache::MemCacheError => error
        lazy_load ||= Hash.new { |hash, hash_key| hash[hash_key] = true; false }

        if error.to_s[/undefined class|referred/] && !lazy_load[error.to_s.split.last.constantize]
          retry
        else
          raise error
        end
      end
    end
  end
end

