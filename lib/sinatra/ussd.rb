require "sinatra/ussd/version"

module Sinatra
  module Ussd
    autoload :Middleware, 'sinatra/ussd/middleware'
    autoload :Adapter, 'sinatra/ussd/adapter'

    autoload :Base, 'sinatra/ussd/base'
    autoload :Caching, 'sinatra/ussd/caching'
  end
end
