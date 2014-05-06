require 'json'
require 'bundler'
Bundler.require :default

require 'sinatra'

module Sinatra
  class Base
    register Sinatra::Ussd::Base
  end
end

post '/new' do
  {
      'message' => 'Welcome to ussd app\n1 greet',
      'response_map' => {
          '1' => '/greet'
      }
  }.to_json
end

post '/greet' do
  {
      'message' => 'Enter Name',
      'response_map' => {
          'text_input' => '/welcome'
      }
  }.to_json
end

post '/welcome' do
  {
      'message' => "Welcome #{message}\n* Back",
      'response_map' => {
          '*' => '/greet'
      }
  }.to_json
end

post '/end' do
  {
      'message' => "Welcome #{message}\n* Back"
  }.to_json
end