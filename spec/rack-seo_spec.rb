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
      @example_page.css("meta[name='description']").text.should_not == orig_meta_description_text
      @example_page.css("meta[name='description']").text.should_not == ""
      @example_page.css("meta[name='description']").text.should_not be_nil
    end

    it "summarises the description based on the text in the page if #content does not exist" do
      orig_meta_description_text = @example_page_without_content_div.css("meta[name='description']").text
      @rack_seo.execute! @example_page_without_content_div
      @example_page_without_content_div.css("meta[name='description']").text.should_not == orig_meta_description_text
      @example_page_without_content_div.css("meta[name='description']").text.should_not == ""
      @example_page_without_content_div.css("meta[name='description']").text.should_not be_nil
    end

    it "summarises the keywords based on the text in #content if it exists"
    it "summarises the keywords based on the text in the page if #content does not exist"
  end
end
