module Sinatra::Ussd::Middleware
  class Dispatcher
    ALLOWED_ATTRS = %w(message response session session_id notice msisdn navigation)
    ALLOWED_RESPONSE_ATTRS = %w(message navigation)

    def initialize(app)
      @app = app
    end

    def call(env)
      @request_body = JSON.parse env['rack.input'].read
      url = resolve_url

      if url.nil?
        @request_body['notice'] = 'Invalid Option'
        build_response([200, {}, @request_body]) do |_, _|
          response = @request_body['response'].clone
          response['response'] = response.clone
          response['notice'] = 'Invalid Option'
          response['session_id'] = @request_body['session_id']
          response['session'] = 'continue'
          response['msisdn'] = @request_body['msisdn']
          response
        end
      else
        prepare_request env
        env['PATH_INFO'] = url

        response = @app.call(env)

        build_response(response) do |status, response|
          response = JSON.parse response.last
          response['response'] = response.clone
          response['session_id'] = @request_body['session_id']
          response['session'] = status == 200 ? 'continue' : 'end'
          response['msisdn'] = @request_body['msisdn']
          response
        end
      end
    end

    private
    def prepare_request(env)
      body = @request_body.to_json.to_s
      env['REQUEST_METHOD'] = 'POST'
      env['CONTENT_LENGTH'] = body.length
      env['rack.input'] = StringIO.new(body)
      env['CONTENT_TYPE'] = 'application/json'
      env['HTTP_ACCEPT'] = 'application/json'
    end

    def build_response(response, &block)
      status, headers, response = response

      response = block.call(status, response)

      response = filter(response, ALLOWED_ATTRS)
      response['response'] = filter(response['response'], ALLOWED_RESPONSE_ATTRS)

      json_response = response.to_json
      headers['Content-Length'] = json_response.length.to_s
      [200, headers, [json_response]]
    end

    def filter(response, allowed)
      response.select {|k,_|  allowed.include?(k) }
    end

    def resolve_url
      session_command = @request_body['session'].to_sym
      case session_command
        when :new
          '/new'
        when :continue
          message = @request_body['message']
          navigation = @request_body.fetch('response', {}).fetch('navigation', {})
          url = navigation.fetch(message, {})
          url = url.fetch('url', nil)
          url = navigation['text_input'].fetch('url') if navigation.fetch('text_input', nil) unless url
          url
        else
          '/end'
      end
    end
  end
end
