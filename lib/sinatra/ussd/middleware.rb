module Sinatra
  module Ussd
    module Middleware
      autoload :Dispatcher, 'sinatra/ussd/middleware/dispatcher'
      autoload :Facade, 'sinatra/ussd/middleware/facade'
      autoload :Echo, 'sinatra/ussd/middleware/echo'
      autoload :MessageBuilder, 'sinatra/ussd/middleware/message_builder'
    end
  end
end