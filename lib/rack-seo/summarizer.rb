class Rack::RackSeo::Summarizer
  class << self
    include Rack::RackSeo::Sanitize

    def extract_description(document, selector)
      sanitize_meta_description get_description(document, selector)
    end

    def extract_keywords(document, selector)
      sanitize_meta_keywords get_keywords(document, selector)
    end
  end

  private
  def self.get_description(document, selector)
    get_selected_elements(document, selector).map {|element|
      element.inner_text
    }.join(' ').summarize(:ratio => 1).strip
  end

  def self.get_keywords(document, selector)
    get_selected_elements(document, selector).map {|element|
      element.inner_text
    }.join(' ').summarize(:topics => true).last
  end

  def self.get_selected_elements(document, selector)
    begin
      elements = document.css(selector) 
    rescue Nokogiri::CSS::SyntaxError => e
      document.css('body')
    end

    if elements.nil? || elements.empty? 
      document.css('body')
    else
      elements
    end
  end
end
