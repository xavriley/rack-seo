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
    it "allows the title text to be configured"
    it "allows the meta description text source material to be narrowed down by a selector"
    it "allows the meta keywords source material to be narrowed down by a selector"
  end

  context "sad config file" do
    it "fails gracefully with a bad title format"
    it "fails gracefully with a bad description selector"
    it "fails gracefully with a bad keywords selector"
  end

end
