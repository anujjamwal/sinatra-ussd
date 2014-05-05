module Sinatra::Ussd::Adapter
  class Default
    def initialize(app)
      @app = app
    end

    # The application expects the requests to be a json of schema
    #  {
    #     'msisdn'    : 'Phone-number'
    #     'message'   : 'User message',
    #     'session'   : 'new' / 'continue' / 'end',
    #     'session_id': 'Session Id'
    #   }
    #
    # The application returns response as json of schema
    #  {
    #     'msisdn'    : 'Phone-number'
    #     'message'   : 'User message',
    #     'session'   : 'new' / 'continue' / 'end',
    #     'session_id': 'Session Id'
    #   }

    def call(env)
      request = build_request env
      response = @app.call request
      build_response response
    end

    def build_request(env)
      env
    end

    def build_response(response)
      response
    end
  end
end