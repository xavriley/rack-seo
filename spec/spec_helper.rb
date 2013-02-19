$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'pry'
require 'rspec'
require 'rack/pagespeed'
require 'rack/pagespeed/store/disk'
require 'fileutils'
require 'tmpdir'
require 'ostruct'
require 'rack-seo'

def fixture name
  File.read(File.join(Fixtures.path, name))
end

module Apps
  class << self
    def complex
      lambda { |env| [200, { 'Content-Type' => 'text/html' }, [fixture('complex.html')]] }
    end

    def plain_text
      lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['plain texto']] }
    end
  end
end

Fixtures = OpenStruct.new unless defined?(Fixtures)
Fixtures.path = File.join(File.dirname(__FILE__), 'fixtures')
Fixtures.complex = Nokogiri::HTML(fixture('complex.html'))
Fixtures.complex = Nokogiri::HTML(fixture('simple.html'))

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before :each do
    Fixtures.complex = Nokogiri::HTML(fixture('complex.html'))
    Fixtures.simple = Nokogiri::HTML(fixture('simple.html'))
  end
end
