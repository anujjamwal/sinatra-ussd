module Sinatra::Ussd::Middleware
  class Facade
    def initialize(app)
      @app = app
    end

    # noinspection RubyArgCount
    def call(env)
      url = env['PATH_INFO']

      aggregator_id = url.scan(/\/ussd\/(.*)\/index/).flatten.first

      klass = Sinatra::Ussd::Adapter.get(aggregator_id)

      unless klass
        message = "Adaptor not found for aggregator #{aggregator_id}"
        return [400, {'Content-Type' => 'application/json'}, [{'error' => message}.to_json]]
      end

      adapter = klass.new(@app)
      adapter.call env
    end
  end
end