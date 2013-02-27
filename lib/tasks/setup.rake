namespace :rack_seo do
  desc "Copies a default config to config/rack_seo.yml"
  task :generate_config => :environment do
    FileUtils.copy(File.expand_path("../../generators/rack_seo.sample.yml", __FILE__), Dir.pwd("config/rack_seo.yml"))
  end
end 
