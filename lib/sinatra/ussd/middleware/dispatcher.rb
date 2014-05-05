module Sinatra::Ussd::Middleware
  class Dispatcher
    def initialize(app)
      @app = app
    end

    def call(env)
      @request_body = JSON.parse env['rack.input'].read
      prepare_request env

      response = @app.call(env)

      build_response(response)
    end

    private
    def prepare_request(env)
      body = @request_body.to_json.to_s
      env['REQUEST_METHOD'] = 'POST'
      env['CONTENT_LENGTH'] = body.length
      env['rack.input'] = StringIO.new(body)
      env['CONTENT_TYPE'] = 'application/json'
      env['HTTP_ACCEPT'] = 'application/json'
      env['PATH_INFO'] = resolve_url
    end

    def build_response(response)
      status, headers, response = response
      response = JSON.parse response.last
      response['response'] = response.clone
      response.delete_if {|k, _| !['message', 'response'].include?(k)}
      response['session_id'] = @request_body['session_id']
      response['session'] = status == 200 ? 'continue' : 'end'
      response['msisdn'] = @request_body['msisdn']
      json_response = response.to_json
      headers['Content-Length'] = json_response.length.to_s
      [200, headers, [json_response]]
    end

    def resolve_url
      session_command = @request_body['session'].to_sym
      case session_command
        when :new
          '/new'
        when :continue
          message = @request_body['message']
          response_map = @request_body['response']['response_map']
          response_map[message]
        else
          '/end'
      end
    end
  end
end
