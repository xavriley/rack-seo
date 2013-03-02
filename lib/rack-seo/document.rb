class Rack::RackSeo::Document < Nokogiri::HTML::Document
  # This is a wrapper for the Nokogiri parsed page
  # Provides some convenience methods for working 
  # with seo meta tags
  attr_accessor :title, :desc, :keywords

  class << self
    def new(*args)
      doc = parse(args.first)
      setup_meta_tags(doc)
    end

    def parse(string_or_io, url = nil, encoding = 'utf-8', options = Nokogiri::XML::ParseOptions::RECOVER)
      super(string_or_io, url, encoding, options)
    end
  end

  def title_content
    self.title_tag.text
  end

  def title_content=(content)
    title_tag.content = content
  end

  def title_tag
    self.at('title')
  end

  def description_content=(content)
    self.description_tag['content'] = content unless description_tag.nil?
  end

  def description_content
    self.description_tag.attr('content') unless description_tag.nil?
  end

  def description_tag
    self.at_css("meta[name='description']")
  end

  def keywords_content=(content)
    keywords_tag['content'] = content unless keywords_tag.nil?
  end

  def keywords_content
    keywords_tag.attr('content') unless keywords_tag.nil?
  end

  def keywords_tag
    self.at_css("meta[name='keywords']")
  end

  class << self
    private

    def setup_meta_tags(document)
      create_html_root_node(document) unless document.root.name == "html" 
      create_doc_head(document) unless document.at_css("head")
      create_meta_title(document) unless document.at_css("title")
      create_meta_desc(document) unless document.at_css("meta[name='description']")
      create_meta_desc_content(document) unless document.at_css("meta[name='description']")['content']
      create_meta_keywords(document) unless document.at_css("meta[name='keywords']")
      create_meta_keywords_content(document) unless document.at_css("meta[name='keywords']")['keywords']
      document
    end

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
      meta_desc['content'] ||= ""
      document.at('head').children.first.after meta_desc
    end

    def create_meta_keywords(document)
      meta_keywords = Nokogiri::XML::Element.new('meta', document)
      meta_keywords['name'] = "keywords"
      meta_keywords['content'] ||= ""
      document.at('head').children.last.after meta_keywords
    end

    def create_meta_desc_content(document)
      meta_desc = document.description_tag
      meta_desc['content'] ||= ""
    end

    def create_meta_keywords_content(document)
      meta_keywords = document.keywords_tag
      meta_keywords['content'] ||= ""
    end
  end

end
