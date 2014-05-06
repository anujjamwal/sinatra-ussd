module Sinatra::Ussd
  class Caching
    def initialize(cache_store = nil, key = 'session_id', only = ['response'])
      @key = key
      @only = only
      @cache_store = cache_store || HashStore.instance
    end

    def populate_request(request)
      key = request[@key]
      cached_data = @cache_store.get_and_clear(key)
      request.merge JSON.parse(cached_data)
    end

    def cache_response response
      json_response = response.clone
      key = json_response[@key]
      json_response.delete_if {|k, v| !@only.include?(k)}
      @cache_store.set(key, json_response.to_json)
      response
    rescue
      response
    end
  end
end