$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'pry'
require 'rspec'
require 'rack/test'
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

    def simple
      lambda { |env| [200, { 'Content-Type' => 'text/html' }, [fixture('simple.html')]] }
    end

    def plain_text
      lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['plain texto']] }
    end
  end
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  include Rack::Test::Methods
  config.before :each do
    Fixtures = OpenStruct.new unless defined?(Fixtures)
    Fixtures.path = File.join(File.dirname(__FILE__), 'fixtures')
    Fixtures.complex = Rack::RackSeo::Document.parse(fixture('complex.html'))
    Fixtures.complex_copy = Rack::RackSeo::Document.parse(fixture('complex.html'))
    Fixtures.simple = Rack::RackSeo::Document.parse(fixture('simple.html'))
    Fixtures.simple_copy = Rack::RackSeo::Document.parse(fixture('simple.html'))
  end
end
