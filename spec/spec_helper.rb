require 'bundler/setup'
Bundler.setup

require 'pry'
require 'json'
require 'sinatra'
require 'sinatra/ussd'
require 'sinatra/contrib'

RSpec.configure do |config|
  config.include Sinatra::TestHelpers
end