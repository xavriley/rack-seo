module Rack
  module RackSeo
    class Base
      attr_accessor :config
      attr_accessor :current_path
      attr_accessor :dispatcher

      def initialize app, options, &block
        @app = app
        if options[:config]
          @config = YAML.load(IO.read(options[:config]))
        else
          @config = YAML.load(IO.read("config/rack_seo.default.yml"))
        end
      end

      def call env
        # Setup document body ready to process
        status, headers, response = @app.call(env)
        return [status, headers, response] unless headers['Content-Type'] =~ /html/
        body = ""; response.each do |part| body << part end

        document = Rack::RackSeo::Document.new(body)
        current_path = env['PATH_INFO'] || '/'
        execute!(document, current_path)

        body = document.to_html
        headers['Content-Length'] = body.length.to_s if headers['Content-Length'] # still UTF-8 unsafe
        [status, headers, [body]]        
      end

      def execute!(document, current_path = '/')
        @dispatcher = RackSeo::Dispatcher.new(@config, current_path)
        set_meta_title(document, @dispatcher.title_format)
        set_meta_description(document, @dispatcher.description_selector)
        set_meta_keywords(document, @dispatcher.keywords_selector)
      end

      def set_meta_title(document, title_format)
        content = Rack::RackSeo::TitleFormatter.parse_meta_title(document, title_format)
        content = Rack::RackSeo::Sanitize.sanitize_meta_title(content)
        document.title_content = content
      end

      def set_meta_description(document, description_selector)
        content = Rack::RackSeo::Summarizer.extract_description(document, description_selector)
        document.description_content = content
      end

      def set_meta_keywords(document, keywords_selector)
        content = Rack::RackSeo::Summarizer.extract_keywords(document, keywords_selector)
        document.keywords_content = content
      end

    end
  end
end
