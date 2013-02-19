class RackSeo < Rack::PageSpeed::Filter
  name    'seo'
  requires_store
  priority 2

  def execute! document
    title = find_or_create_meta_title(document)
    title.content = get_text_from_css(document, "h1")
  end

  def find_or_create_meta_title document
    if doc_title = document.css('title').first
    else 
      Nokogiri::XML::Element.new('title', document)
      document.at('head').children.first.before doc_title.children.first.before
    end
    doc_title
  end

  def get_text_from_css(document, selector)
    element = document.css(selector).first
    element && element.text || ""
  end
end
