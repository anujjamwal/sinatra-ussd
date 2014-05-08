[![Build Status](https://travis-ci.org/anujjamwal/sinatra-ussd.svg?branch=master)](https://travis-ci.org/anujjamwal/sinatra-ussd)

# Sinatra::Ussd

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-ussd'

And then execute:

    $ bundle

## Example

```ruby
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
```
For check out integration_spec.rb or examples

## Aggregator Adapter

The adapters are used to convert the request response to the application format. The application expects

### Request format the app expects
```json
      {
         'msisdn'    : 'Phone-number'
         'message'   : 'User message',
         'session'   : 'new' / 'continue' / 'end',
         'session_id': 'Session Id'
       }
```

### Response sent by the application
```json
      {
         'msisdn'    : 'Phone-number'
         'message'   : 'User message',
         'session'   : 'new' / 'continue' / 'end',
         'session_id': 'Session Id'
       }
```