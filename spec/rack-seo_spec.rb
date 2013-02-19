require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "RackSeo" do
  before do
    @rack_seo = RackSeo.new :public => Fixtures.path, :store => {}
    @env = Rack::MockRequest.env_for '/'
  end

  context "sensible defaults" do
    it "pulls the h1 tag into the meta title by default" do
      orig_meta_title = @rack_seo.css('title')
      orig_h1 = @rack_seo.css('h1').first
      @rack_seo.execute!
      new_meta_title = @rack_seo.css('title')
      new_h1 = @rack_seo.css('h1').first
      new_meta_title.should == orig_h1
      new_meta_title.should_not ==  orig_h1
    end

    it "summarises the description based on the text in #content if it exists"
    it "summarises the description based on the text in the page if #content does not exist"
    it "summarises the keywords based on the text in #content if it exists"
    it "summarises the keywords based on the text in the page if #content does not exist"
  end
end
