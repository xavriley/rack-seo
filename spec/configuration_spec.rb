require 'summarize'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "RackSeo Configuration" do
  before do
    @env = Rack::MockRequest.env_for '/'
  end

  it "reads a configuration file specified in the initializer" do
    @rack_seo = Rack::RackSeo::Base.new Apps.complex, :public => Fixtures.path, :config => "config/rack_seo.default.yml"
  end

  context "happy config file" do
    before do
      @rack_seo = Rack::RackSeo::Base.new Apps.complex, :public => Fixtures.path, :config => "spec/sample_configs/happy.yml"
      @rack_seo_default = Rack::RackSeo::Base.new Apps.complex, :public => Fixtures.path
      @happy_page = Fixtures.complex
      @default_page = Fixtures.complex_copy
      @rack_seo.execute! @happy_page
      @rack_seo_default.execute! @default_page
    end
    it "allows the title text to be configured" do
      @happy_page.at_css('title').text.should include "#{(@happy_page.at_css('h1').text)} - Happy happy"
    end
    it "allows the meta description text source material to be narrowed down by a selector" do
      @happy_page.at_css("meta[name='description']").attr('content').should_not == @default_page.at_css("meta[name='description']").attr('content')
    end
    it "allows the meta keywords source material to be narrowed down by a selector" do
      @happy_page.at_css("meta[name='keywords']").attr('content').should_not == @default_page.at_css("meta[name='keywords']").attr('content')
    end
  end

  context "sad config file" do
    before do
      @rack_seo = Rack::RackSeo::Base.new Apps.simple, :public => Fixtures.path, :config => "spec/sample_configs/sad.yml"
      @sad_page = Fixtures.simple
      @rack_seo.execute! @sad_page
    end
    it "fails gracefully with a bad title, description or keyword selector" do
      inner_app = lambda { |env| [200, {'Content-Type' => 'text/html'}, [@sad_page.to_html]] }
      status, headers, body = @rack_seo.call(@env)
      status.should == 200
      #TODO double check this test
    end
  end

  context "configuring formats based on paths" do
    before do
      @page = Fixtures.complex
      @rack_seo = Rack::RackSeo::Base.new Apps.complex, :public => Fixtures.path
      @env = Rack::MockRequest.env_for '/'
      status, headers, body = @rack_seo.call(@env)
      @response_body = Nokogiri::HTML(body.first)

      @page_test = Fixtures.complex_copy
      @rack_seo_test = Rack::RackSeo::Base.new Apps.complex, :public => Fixtures.path, :config => "spec/sample_configs/custom_paths.yml"
    end

    context "matching path based on a string" do
      before do
        env_test = Rack::MockRequest.env_for '/test-path'
        status, headers, body = @rack_seo_test.call(env_test)
        @response_body_test = Nokogiri::HTML(body.first)
      end

      it "allows title_format to be configured for a certain path" do
        @response_body_test.at_css('title').should_not == @response_body.at_css('title')
      end
      it "allows meta_description_selector to be configured for a certain path" do
        @response_body_test.at_css("meta[name='description']")['content'].should_not == @response_body.at_css("meta[name='description']")['content']
      end
      it "allows meta_keywords_selector to be configured for a certain path" do
        @response_body_test.at_css("meta[name='keywords']")['content'].should_not == @response_body.at_css("meta[name='keywords']")['content']
      end
    end

    context "matching path based on a Regexp" do
      before do
        env_test = Rack::MockRequest.env_for '/test-regex-two/subfolder'
        status, headers, body = @rack_seo_test.call(env_test)
        @response_body_test = Nokogiri::HTML(body.first)
      end

      it "allows title_format to be configured for a certain path" do
        @response_body_test.at_css('title').should_not == @response_body.at_css('title')
        @response_body_test.at_css('title').text.should include('regex')
      end
      it "allows meta_description_selector to be configured for a certain path" do
        @response_body_test.at_css("meta[name='description']")['content'].should_not == @response_body.at_css("meta[name='description']")['content']
      end
      it "allows meta_keywords_selector to be configured for a certain path" do
        @response_body_test.at_css("meta[name='keywords']")['content'].should_not == @response_body.at_css("meta[name='keywords']")['content']
      end
    end

  end
end
