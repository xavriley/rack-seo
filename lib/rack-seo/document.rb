class Rack::RackSeo::Document < Nokogiri::HTML::Document
  # This is a wrapper for the Nokogiri parsed page
  # Provides some convenience methods for working 
  # with seo meta tags
  attr_accessor :title, :desc, :keywords

  def title_content
    title_tag.text
  end

  def title_tag
    at('title')
  end

  def description_content
    description_tag.attr('content') unless description_tag.nil?
  end

  def description_tag
    at_css("meta[name='description']")
  end

  def keywords_content
    keywords_tag.attr('content') unless keywords_tag.nil?
  end

  def keywords_tag
    at_css("meta[name='keywords']")
  end

end
