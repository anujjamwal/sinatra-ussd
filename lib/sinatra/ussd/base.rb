module Sinatra
  module Ussd
    module Base

      def self.registered(app)
        cache_store = app.settings.respond_to?(:cache_store) ? app.settings.cache_store : Sinatra::Ussd::HashStore.instance
        caching = Sinatra::Ussd::Caching.new(cache_store)

        app.use Sinatra::Ussd::Middleware::Facade
        app.use Sinatra::Ussd::Middleware::Echo, caching
        app.use Sinatra::Ussd::Middleware::MessageBuilder
        app.use Sinatra::Ussd::Middleware::Dispatcher

        app.before {
          @params = ::JSON.parse(request.body.read)
        }

        app.helpers Sinatra::Ussd::Helpers::Message
      end
    end
  end
end
