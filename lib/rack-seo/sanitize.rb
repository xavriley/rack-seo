module Rack::RackSeo::Sanitize
  def self.sanitize_meta_title(title)
    title.to_s.gsub(/\s+/, ' ').strip
  end

  def sanitize_meta_description(meta_description)
    meta_description.to_s.gsub(/[\s]+/, ' ').gsub(/[\r|\n]+/, ' ').strip
  end

  def sanitize_meta_keywords(keywords)
    keywords.split(",").collect { |keyword| 
      keyword.downcase.gsub(/\s+/, '')
    }.reject(&:empty?).join(',')
  end
end
