require 'singleton'
module Sinatra::Ussd
  class HashStore
    include Singleton

    def initialize
      @store = {}
    end

    def get(key)
      @store.fetch(key, '{}')
    end

    def set(key, value)
      @store[key] = value
    end

    def get_and_clear(key)
      value = @store.fetch(key, '{}')
      @store.delete(key)
      value
    end
  end
end