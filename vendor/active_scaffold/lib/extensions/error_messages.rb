module ActiveRecord
  class Errors
    # uses config.columns[attr].label instead of attr.humanize, for improved consistency in form feedback.
    # also passes strings through as_(), since it's handy.
    def as_full_messages(config)
      @as_config = config
      full_messages = []

      @errors.each_key do |attr|
        @errors[attr].each do |msg|
          next if msg.nil?

          if attr == "base"
            full_messages << as_(msg)
          else
            label = as_(config.columns[attr].label) if config and config.columns[attr]
            label ||= @base.class.human_attribute_name(attr)
            full_messages << label + " " + as_(msg)
          end
        end
      end
      full_messages
    end
  end
end

module ActionView
  module Helpers
    module ActiveRecordHelper
      # overrides the standard error_messages_for() to use our own as_full_messages()
      # also passes strings through as_(), since it's handy.
      def error_messages_for(*params)
        options = params.extract_options!.symbolize_keys

        if object = options.delete(:object)
          objects = [object].flatten
        else
          objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
        end

        count  = objects.inject(0) {|sum, object| sum + object.errors.count }
        unless count.zero?
          html = {}
          [:id, :class].each do |key|
            if options.include?(key)
              value = options[key]
              html[key] = value unless value.blank?
            else
              html[key] = 'errorExplanation'
            end
          end
          options[:object_name] ||= params.first

          I18n.with_options :locale => options[:locale], :scope => [:activerecord, :errors, :template] do |locale|
            header_message = if options.include?(:header_message)
              options[:header_message]
            else
              object_name = options[:object_name].to_s.gsub('_', ' ')
              object_name = I18n.t(object_name, :default => object_name, :scope => [:activerecord, :models], :count => 1)
              locale.t :header, :count => count, :model => object_name
            end
            message = options.include?(:message) ? options[:message] : locale.t(:body)
            #error_messages = objects.sum {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }.join

            error_messages = objects.map {|object| 
              object.errors.as_full_messages(active_scaffold_config).map {|msg| content_tag(:li, msg) } 
            }

            contents = ''
            contents << content_tag(options[:header_tag] || :h2, header_message) unless header_message.blank?
            contents << content_tag(:p, message) unless message.blank?
            contents << content_tag(:ul, error_messages)

            content_tag(:div, contents, html)
          end
        else
          ''
        end
      end
    end
  end
end
