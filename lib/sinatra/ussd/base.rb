module Sinatra
  module Ussd
    module Base

      def self.registered(app)
        app.use Sinatra::Ussd::Middleware::Facade
        app.use Sinatra::Ussd::Middleware::Echo
        app.use Sinatra::Ussd::Middleware::Dispatcher

        app.before {
          @params = ::JSON.parse(request.body.read)
        }
      end
    end
  end
end
