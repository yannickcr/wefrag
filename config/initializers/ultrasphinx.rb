if defined?(Ultrasphinx)
  Ultrasphinx::Search.client_options[:finder_methods].unshift(:find_with_includes)
end
