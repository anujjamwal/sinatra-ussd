module Sinatra::Ussd::Helpers
  module Message
    def message
      @params.fetch('message')
    end
  end
end