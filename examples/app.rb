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
      'message' => 'Welcome to ussd app',
      'navigation' => {
          '1' => {'url' => '/greet', 'label' => 'greet'}
      }
  }.to_json
end

post '/greet' do
  {
      'message' => 'Enter Name',
      'navigation' => {
          'text_input' => {'url' => '/welcome'}
      }
  }.to_json
end

post '/welcome' do
  {
      'message' => "Welcome #{message}",
      'navigation' => {
          '*' => {'url' => '/greet', 'label' => 'Back'}
      }
  }.to_json
end

post '/end' do
  {
      'message' => "Bye Bye"
  }.to_json
end