require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "RackSeo" do
  before do
    @rack_seo = Rack::RackSeo::Base.new Apps.complex, :public => Fixtures.path
    @env = Rack::MockRequest.env_for '/'
  end

  context "has sensible defaults" do
    context "for a page with a #content div" do
      before do
        @example_page = Fixtures.complex
        @orig_meta_title_text = @example_page.css('title').text
        @orig_meta_description_text = @example_page.css("meta[name='description']").text
        @orig_meta_keywords_text = @example_page.css("meta[name='keywords']").text
        @orig_h1_text = @example_page.css('h1').text
        @rack_seo.execute! @example_page
      end

      it "pulls the h1 tag into the meta title by default" do
        @example_page.css('title').text.should == @orig_h1_text
        @example_page.css('title').text.should_not ==  @orig_meta_title_text
      end

      it "summarises the description based on the text in #content if it exists" do
        @example_page.css("meta[name='description']").attr('content').should_not == @orig_meta_description_text
        @example_page.css("meta[name='description']").attr('content').should_not == ""
        @example_page.css("meta[name='description']").attr('content').should_not be_nil
      end

      it "summarises the keywords based on the text in #content if it exists" do
        @example_page.css("meta[name='keywords']").attr('content').should_not == @orig_meta_keywords_text
        @example_page.css("meta[name='keywords']").attr('content').should_not == ""
        @example_page.css("meta[name='keywords']").attr('content').should_not be_nil
      end
    end

    context "for a page without #content div" do
      before do
        @example_page_without_content_div = Fixtures.simple
        @orig_meta_description_text = @example_page_without_content_div.css("meta[name='description']").text
        @orig_meta_keywords_text = @example_page_without_content_div.css("meta[name='keywords']").text
        @rack_seo.execute! @example_page_without_content_div
      end
      it "summarises the description based on the text in the page if #content does not exist" do
        @example_page_without_content_div.css("meta[name='description']").attr('content').should_not == @orig_meta_description_text
        @example_page_without_content_div.css("meta[name='description']").attr('content').should_not == ""
        @example_page_without_content_div.css("meta[name='description']").attr('content').should_not be_nil
      end

      it "summarises the keywords based on the text in the page if #content does not exist" do
        @example_page_without_content_div.css("meta[name='keywords']").attr('content').should_not == @orig_meta_keywords_text
        @example_page_without_content_div.css("meta[name='keywords']").attr('content').should_not == ""
        @example_page_without_content_div.css("meta[name='keywords']").attr('content').should_not be_nil
      end
    end

  end

  context "validate output" do
    before do
      @example_page = Fixtures.complex
      @rack_seo.execute! @example_page
    end

    it "should have a head tag that is the first child of the root node" do
      @example_page.root.children.first.should == @example_page.at('head')
    end
    it "should have a title that is less that 65 chars and 15 words" do
      title = @example_page.at('title')
      title.text.length.should be <= 65
      title.text.split(/\b/).length.should be > 1
      title.text.split(/\b/).length.should be <= 15
    end
    it "should have a meta description with content that is less than 150 chars and 30 words" do
      description = @example_page.at("meta[name='description']").attr('content')
      description.split(/\b/).length.should be > 1
      pending("A better text summarizer with more control over length")
      description.split(/\b/).length.should be <= 100
      description.length.should be <= 150 
      description.split(/\b/).length.should be <= 30 
    end
    it "should have meta keywords with content that is a lowercase, comma separated list, without leading/trailing commas" do
      keywords = @example_page.at("meta[name='keywords']").attr('content')
      keywords.should match /[a-z,]+/
      keywords.should_not match /\A,/
      keywords.should_not match /,\Z/
      keywords.split(/,/).length.should be > 1 
    end
    it "has a title that is readable (no line breaks or leading/trailing spaces)" do
      title = @example_page.at('title')
      title.text.should_not match(/\A\s/)
      title.text.should_not match(/\n+/)
      title.text.should_not match(/\s\s+/)
      title.text.should_not match(/\t+/)
      title.text.should_not match(/\s\Z/)
    end
    it "provides a readable paragraph for the meta_description (no line breaks or leading/trailing spaces)" do
      meta_description = @example_page.at("meta[name='description']").attr('content')
      meta_description.should_not match(/\A\s/)
      meta_description.should_not match(/\n+/)
      meta_description.should_not match(/\s\s+/)
      meta_description.should_not match(/\t+/)
      meta_description.should_not match(/\s\Z/)
    end
  end

end
