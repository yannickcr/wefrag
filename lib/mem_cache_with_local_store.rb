class MemCacheWithLocalStore < ActiveSupport::Cache::MemCacheStore
  def initialize(*addresses)
    @local_cache = {}
    super(addresses)
  end

  def read(key, options = nil)
    autoload_missing_constants do
      @local_cache[key] = super(key, options) if @local_cache[key].nil?
      @local_cache[key]
    end
  end

  def write(key, value, options)
    @local_cache[key] = value
    super(key, value, options) unless options && options[:local]
  end

  def clear
    @local_cache.clear
    super
  end

  def delete(key, options = nil)
    @local_cache[key] = nil
    super(key, options)
  end

  def fetch(key, options = {})
    if !options[:force] && value = read(key, options) or !value.nil?
      value
    elsif block_given?
      value = yield
      write(key, value, options)
      value
    end
  end

  def clear_local_cache
    @local_cache = {}
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

