class Rack::RackSeo::TitleFormatter

  def self.parse_meta_title(document, title_format)
    title_format.gsub(/{{([^\}]+)}}/) do
      "#{document.css($1).first.text rescue nil}"
    end
  end

end
