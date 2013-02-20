require 'summarize'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "RackSeo Configuration" do

  it "reads a configuration file specified in the initializer" do
    @rack_seo = RackSeo.new :public => Fixtures.path, :store => {}, :config => "config/rack_seo.default.yml"
  end

  it "reads a configuration file from config/rack_seo.yml by default" do
    pending "how I mock a config/yml file"
    @rack_seo = RackSeo.new :public => Fixtures.path, :store => {}
  end

  context "happy config file" do
    before do
      @rack_seo = RackSeo.new :public => Fixtures.path, :store => {}, :config => "spec/sample_configs/happy.yml"
      @rack_seo_default = RackSeo.new :public => Fixtures.path, :store => {}
      @happy_page = Fixtures.complex
      @default_page = Fixtures.complex
      @rack_seo.execute! @happy_page
      @rack_seo_default.execute! @default_page
    end
    it "allows the title text to be configured" do
      @happy_page.at_css('title').text.should include "#{(@happy_page.at_css('h1').text)} - Happy happy"
    end
    it "allows the meta description text source material to be narrowed down by a selector" do
      @happy_page.at_css("meta[name='description']").attr('content').should_not == @default_page.at_css("meta[name='description']").attr('content')
    end
    it "allows the meta keywords source material to be narrowed down by a selector"
  end

  context "sad config file" do
    it "fails gracefully with a bad title format"
    it "fails gracefully with a bad description selector"
    it "fails gracefully with a bad keywords selector"
  end

end
