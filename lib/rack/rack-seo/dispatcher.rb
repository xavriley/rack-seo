module Rack
  module RackSeo
    class Dispatcher
      attr_accessor :title_format
      attr_accessor :meta_description_selector
      attr_accessor :meta_keywords_selector

      def initialize(config, current_path)
        if config["custom"]
          config["custom"].each do |custom_path|
            if custom_path["matcher"].is_a?(String) && current_path.include?(custom_path["matcher"])
              @title_format = custom_path["title_format"]
              @meta_description_selector = custom_path["meta_description_selector"]
              @meta_keywords_selector = custom_path["meta_keywords_selector"]
            elsif custom_path["matcher"].is_a?(Regexp) && current_path =~ custom_path["matcher"]
              @title_format = custom_path["title_format"]
              @meta_description_selector = custom_path["meta_description_selector"]
              @meta_keywords_selector = custom_path["meta_keywords_selector"]
            end
          end
        else
          @title_format ||= config["default"]["title_format"]
          @meta_description_selector ||= config["default"]["meta_description_selector"]
          @meta_keywords_selector ||= config["default"]["meta_keywords_selector"]
        end
      end

    end
  end
end
