require 'rack'
require_relative 'dispatcher'
require 'nokogiri'
require 'yaml'
require 'summarize'
module Rack
  module RackSeo
    class Base
      attr_accessor :config
      attr_accessor :current_path
      attr_accessor :dispatcher

      def initialize app, options, &block
        @app = app
        @current_path = "/"
        if options[:config]
          @config = YAML.load(IO.read(options[:config]))
        else
          @config = YAML.load(IO.read("config/rack_seo.default.yml"))
        end
        @dispatcher = RackSeo::Dispatcher.new(@config, @current_path)
      end

      def call env
        @current_path = env['PATH_INFO']
        status, headers, @response = @app.call(env)
        return [status, headers, @response] unless headers['Content-Type'] =~ /html/
        body = ""; @response.each do |part| body << part end
        @document = Nokogiri::HTML(body)
        execute! @document
        body = @document.to_html
        headers['Content-Length'] = body.length.to_s if headers['Content-Length'] # still UTF-8 unsafe
        [status, headers, [body]]        
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
        content = parse_meta_title(document, get_title_format)
        content = sanitize_meta_title(content)
        title_tag = find_meta_title(document)
        title_tag.content = content
      end

      def set_meta_description(document)
        meta_description_tag = find_meta_desc(document)
        meta_description_selector = find_selector(document, get_meta_description_selector).nil? ? "body" : get_meta_description_selector
        content = get_inner_text_from_css(document, meta_description_selector).summarize(:ratio => 1)
        meta_description_tag['content'] = sanitize_meta_description(content)
      end

      def set_meta_keywords(document)
        meta_keywords_tag = find_meta_keywords(document)
        meta_keywords_selector = find_selector(document, get_meta_keywords_selector).nil? ? "body" : get_meta_keywords_selector
        content = get_inner_text_from_css(document, meta_keywords_selector).summarize(:topics => true).last
        meta_keywords_tag['content'] = sanitize_meta_keywords(content)
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

      def find_selector(document, selector)
        document.at_css(selector) rescue nil
      end

      def parse_meta_title(document, title_format)
        title_format.gsub(/{{([^\}]+)}}/) do
          "#{document.css($1).first.text rescue nil}"
        end
      end

      def sanitize_meta_title(title)
        title.to_s.gsub(/\s+/, ' ').strip
      end

      def sanitize_meta_description(meta_description)
        meta_description.to_s.gsub(/\s+/, ' ').strip
      end

      def sanitize_meta_keywords(keywords)
        keywords.split(",").collect { |keyword| 
          keyword.downcase.gsub(/\s+/, '')
        }.reject(&:empty?).join(',')
      end

      def get_title_format
        @dispatcher.title_format
      end

      def get_meta_description_selector
        @dispatcher.meta_description_selector
      end

      def get_meta_keywords_selector
        @dispatcher.meta_keywords_selector
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
        element = find_selector(document, selector)
        element && element.text || ""
      end

      def get_inner_text_from_css(document, selector)
        element = find_selector(document, selector)
        element && element.inner_text || ""
      end
    end
  end
end
