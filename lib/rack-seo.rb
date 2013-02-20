require 'summarize'
class RackSeo < Rack::PageSpeed::Filter
  name    'seo'
  requires_store
  priority 2

  def execute!(document)
    setup_meta_tags(document)
    set_meta_title(document)
    set_meta_description(document)
    set_meta_keywords(document)
  end

  def setup_meta_tags(document)
    doc_head = document.at_css("head") || create_doc_head(document)
    meta_title = document.at_css("title") || create_meta_title(document)
    meta_desc = document.at_css("meta[name='description']") || create_meta_desc(document)
    meta_keywords = document.at_css("meta[name='keywords']") || create_meta_keywords(document)
  end

  def set_meta_title(document)
    title = find_meta_title(document)
    title.content = get_text_from_css(document, "h1")
  end

  def set_meta_description(document)
    meta_desc = find_meta_desc(document)
    if document.at_css("#content")
      meta_desc['content'] = get_inner_text_from_css(document, "#content").summarize(:ratio => 10)
    else
      meta_desc['content'] = get_inner_text_from_css(document, "body").summarize(:ratio => 10)
    end
  end

  def set_meta_keywords(document)
    meta_keywords = find_meta_keywords(document)
    if document.at_css("#content")
      meta_keywords['content'] = get_inner_text_from_css(document, "#content").summarize(:topics => true).last
    else
      meta_keywords['content'] = get_inner_text_from_css(document, "body").summarize(:topics => true).last
    end
  end

  def find_meta_title(document)
    document.at('title') 
  end

  def find_meta_desc(document)
    document.at_css("meta[name='description']")
  end

  def find_meta_keywords(document)
    document.at_css("meta[name='keywords']")
  end

  private

  def create_doc_head(document)
    doc_head = Nokogiri::XML::Element.new('head', document)
    document.root.add_child doc_head
  end

  def create_meta_title(document)
    meta_title = Nokogiri::XML::Element.new('title', document)
    document.at('head').add_child meta_title
  end

  def create_meta_desc(document)
    meta_desc = Nokogiri::XML::Element.new('meta', document)
    meta_desc['name'] = "description"
    document.at('head').children.first.after meta_desc
  end

  def create_meta_keywords(document)
    meta_keywords = Nokogiri::XML::Element.new('meta', document)
    meta_keywords['name'] = "keywords"
    document.at('head').children.last.after meta_keywords
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
