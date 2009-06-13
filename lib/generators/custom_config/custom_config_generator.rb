class CustomConfigGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template 'config/initializers/custom_config.rb', 'config/initializers/zzz_custom_config.rb'
    end
  end
end

