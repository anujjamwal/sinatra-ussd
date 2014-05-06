module Sinatra
  module Ussd
    module Adapter
      autoload :Default, 'sinatra/ussd/adapter/default'

      def self.get(aggregator_id)
        Kernel.const_get "Sinatra::Ussd::Adapter::#{aggregator_id.to_s.capitalize}"
      rescue
        nil
      end
    end
  end
end