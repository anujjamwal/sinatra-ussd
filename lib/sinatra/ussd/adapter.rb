module Sinatra
  module Ussd
    module Adapter
      autoload :Default, 'sinatra/ussd/adapter/default'

      def self.get(aggregator_id)
        "Sinatra::Ussd::Adapter::#{aggregator_id.to_s.capitalize}".constantize
      rescue
        nil
      end
    end
  end
end