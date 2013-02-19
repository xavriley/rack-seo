require 'summarize'
class RackSeo < Rack::PageSpeed::Filter
  name    'seo'
  requires_store
  priority 2

  def execute!(document)
    set_meta_title(document)
    set_meta_description(document)
  end

  def set_meta_title(document)
    title = find_or_create_meta_title(document)
    title.content = get_text_from_css(document, "h1")
  end

  def set_meta_description(document)
    meta_desc = find_or_create_meta_desc(document)
    meta_desc.content = get_inner_text_from_css(document, "#content").summarize(:ratio => 10)
  end

  def find_or_create_meta_title(document)
    if doc_title = document.css('title').first
    else 
      Nokogiri::XML::Element.new('title', document)
      document.at('head').children.first.before doc_title.children.first.before
    end
    doc_title
  end

  def find_or_create_meta_desc(document)
    if meta_desc = document.css("meta[name='description']").first
    else 
      meta_desc = Nokogiri::XML::Element.new("meta", document)
      meta_desc['name'] = "description"
      document.at('head').children.first.after meta_desc
    end
    meta_desc
  end

  def get_text_from_css(document, selector)
    element = document.css(selector).first
    element && element.text || ""
  end

  def get_inner_text_from_css(document, selector)
    element = document.css(selector).first
    element && element.inner_text || ""
  end
end
