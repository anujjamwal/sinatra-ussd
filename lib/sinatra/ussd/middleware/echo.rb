module Sinatra::Ussd::Middleware
  class Echo
    def initialize(app, caching = nil)
      @app = app
      @caching = caching || Sinatra::Ussd::Caching.new
    end

    # noinspection RubyArgCount
    def call(env)
      request_body = JSON.parse(env['rack.input'].read)
      json_request = @caching.populate_request(request_body.clone)
      env['rack.input'] = StringIO.new(json_request.to_json)

      status, header, response = @app.call(env)

      json_response = JSON.parse(response.last)
      @caching.cache_response(json_response)
      return status, header, response
    end
  end
end