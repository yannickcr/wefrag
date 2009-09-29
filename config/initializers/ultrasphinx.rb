if defined?(Ultrasphinx)
  Ultrasphinx::Search.client_options[:finder_methods].unshift(:find_with_includes)

  Ultrasphinx::Search.query_defaults = HashWithIndifferentAccess.new({
    :query       => nil,
    :page        => 1,
    :per_page    => 25,
    :sort_by     => 'created_at',
    :sort_mode   => 'descending',
    :indexes     => [
      Ultrasphinx::MAIN_INDEX,
      (Ultrasphinx::DELTA_INDEX if Ultrasphinx.delta_index_present?)
    ].compact,
    :weights     => {},
    :class_names => [],
    :filters     => {},
    :facets      => [],
    :location    => HashWithIndifferentAccess.new({                                                                                                                   
      :lat_attribute_name  => 'lat',
      :long_attribute_name => 'lng',
      :units               => 'radians'
    })
  })

  Ultrasphinx::Search.excerpting_options = HashWithIndifferentAccess.new({
    :before_match    => '[b]',
    :after_match     => '[/b]',
    :chunk_separator => '...',
    :limit           => 512,
    :around          => 3,
    :content_methods => ['body']
  })
end
