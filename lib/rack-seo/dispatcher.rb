class Rack::RackSeo::Dispatcher
  attr_accessor :title_format
  attr_accessor :meta_description_selector
  attr_accessor :meta_keywords_selector

  def initialize(config, current_path)
    if config["custom"]
      matching_path = config["custom"].detect do |custom_path|
        (custom_path["matcher"].is_a?(String) && current_path.include?(custom_path["matcher"])) or
        (custom_path["matcher"].is_a?(Regexp) && current_path =~ custom_path["matcher"])
      end
    end
    matching_path ||= {}
    @title_format = matching_path["title_format"] || config["default"]["title_format"]
    @meta_description_selector = matching_path["meta_description_selector"] || config["default"]["meta_description_selector"]
    @meta_keywords_selector = matching_path["meta_keywords_selector"] || config["default"]["meta_keywords_selector"]
  end

end
