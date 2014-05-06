module Sinatra::Ussd::Middleware
  class MessageBuilder
    def initialize(app)
      @app = app
    end

    # noinspection RubyArgCount
    def call(env)
      status, header, response = @app.call(env)

      json_response = JSON.parse(response.last)
      if json_response['notice']
        json_response['message'] = [json_response['notice'], json_response['message']].join("\n\n")
        json_response.delete 'notice'
      end
      body = json_response.to_json.to_s
      header['Content-Length'] = body.length.to_s
      return status, header, [body]
    end
  end
end