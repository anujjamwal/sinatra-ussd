require "sinatra/ussd/version"

module Sinatra
  module Ussd
    autoload :Adapter, 'sinatra/ussd/adapter'
    autoload :Helpers, 'sinatra/ussd/helpers'

    autoload :HashStore, 'sinatra/ussd/cache_store'

    autoload :Base, 'sinatra/ussd/base'
    autoload :Caching, 'sinatra/ussd/caching'

    module Middleware
      autoload :Dispatcher, 'sinatra/ussd/middleware/dispatcher'
      autoload :Facade, 'sinatra/ussd/middleware/facade'
      autoload :Echo, 'sinatra/ussd/middleware/echo'
      autoload :MessageBuilder, 'sinatra/ussd/middleware/message_builder'
    end

    module Helpers
      autoload :Message, 'sinatra/ussd/helpers/message'
    end
  end
end
