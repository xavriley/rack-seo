require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "RackSeo" do
  before do
    @rack_seo = RackSeo.new :public => Fixtures.path, :store => {}
    @env = Rack::MockRequest.env_for '/'
  end

  context "sensible defaults" do
    before do
      @example_page = Fixtures.complex
      @example_page_without_content_div = Fixtures.simple
    end

    it "pulls the h1 tag into the meta title by default" do
      orig_meta_title_text = @example_page.css('title').text
      orig_h1_text = @example_page.css('h1').text
      @rack_seo.execute! @example_page
      @example_page.css('title').text.should == orig_h1_text
      @example_page.css('title').text.should_not ==  orig_meta_title_text
    end

    it "summarises the description based on the text in #content if it exists" do
      orig_meta_description_text = @example_page.css("meta[name='description']").text
      @rack_seo.execute! @example_page
      @example_page.css("meta[name='description']").attr('content').should_not == orig_meta_description_text
      @example_page.css("meta[name='description']").attr('content').should_not == ""
      @example_page.css("meta[name='description']").attr('content').should_not be_nil
    end

    it "summarises the description based on the text in the page if #content does not exist" do
      orig_meta_description_text = @example_page_without_content_div.css("meta[name='description']").text
      @rack_seo.execute! @example_page_without_content_div
      @example_page_without_content_div.css("meta[name='description']").attr('content').should_not == orig_meta_description_text
      @example_page_without_content_div.css("meta[name='description']").attr('content').should_not == ""
      @example_page_without_content_div.css("meta[name='description']").attr('content').should_not be_nil
    end

    it "summarises the keywords based on the text in #content if it exists" do
      orig_meta_keywords_text = @example_page.css("meta[name='keywords']").text
      @rack_seo.execute! @example_page
      @example_page.css("meta[name='keywords']").attr('content').should_not == orig_meta_keywords_text
      @example_page.css("meta[name='keywords']").attr('content').should_not == ""
      @example_page.css("meta[name='keywords']").attr('content').should_not be_nil
    end

    it "summarises the keywords based on the text in the page if #content does not exist" do
      orig_meta_keywords_text = @example_page_without_content_div.css("meta[name='keywords']").text
      @rack_seo.execute! @example_page_without_content_div
      @example_page_without_content_div.css("meta[name='keywords']").attr('content').should_not == orig_meta_keywords_text
      @example_page_without_content_div.css("meta[name='keywords']").attr('content').should_not == ""
      @example_page_without_content_div.css("meta[name='keywords']").attr('content').should_not be_nil
    end
  end

  context "validate output" do
    it "should have a title that is less that 160 chars"
    it "should have a meta description with content that is less that 200 chars"
    it "should have meta keywords with content that is a lowercase, comma separated list"
  end

end
