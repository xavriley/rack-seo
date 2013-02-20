require 'yaml'
require 'summarize'
class RackSeo < Rack::PageSpeed::Filter
  name    'seo'
  requires_store
  priority 2

  def self.new options = {}
    if options[:config]
      config = YAML.load(IO.read(options[:config]))
    else
      config = YAML.load(IO.read("config/rack_seo.default.yml"))
    end
    @@title_format = config["default"]["title_format"]
    @@meta_description_selector =  config["default"]["meta_description_selector"]
    @@meta_keywords_selector = config["default"]["meta_keywords_selector"]
    super(options)
  end

  def execute!(document)
    setup_meta_tags(document)
    set_meta_title(document)
    set_meta_description(document)
    set_meta_keywords(document)
  end

  def setup_meta_tags(document)
    create_html_root_node(document) unless document.root.name == "html" 
    doc_head = document.at_css("head") || create_doc_head(document)
    meta_title = document.at_css("title") || create_meta_title(document)
    meta_desc = document.at_css("meta[name='description']") || create_meta_desc(document)
    meta_keywords = document.at_css("meta[name='keywords']") || create_meta_keywords(document)
  end

  def set_meta_title(document)
    title = find_meta_title(document)
    content = parse_meta_title(document, @@title_format)
    title.content = content
  end

  def set_meta_description(document)
    meta_desc = find_meta_desc(document)
    if document.at_css(@@meta_description_selector)
      meta_desc['content'] = get_inner_text_from_css(document, @@meta_description_selector).summarize(:ratio => 1)
    else
      meta_desc['content'] = get_inner_text_from_css(document, "body").summarize(:ratio => 1)
    end
  end

  def set_meta_keywords(document)
    meta_keywords = find_meta_keywords(document)
    if document.at_css(@@meta_keywords_selector)
      meta_keywords['content'] = get_inner_text_from_css(document, @@meta_keywords_selector).summarize(:topics => true).last
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

  def parse_meta_title(document, title_format)
    title_format.gsub(/{{([^\}]+)}}/) do
      "#{document.css($1).first.text rescue nil}"
    end
  end

  private
  def create_html_root_node(document)
    document.root.wrap('<html></html>')
  end

  def create_doc_head(document)
    doc_head = Nokogiri::XML::Element.new('head', document)
    document.root.children.first.before doc_head
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
