module Sinatra::Ussd::Middleware
  class MessageBuilder
    def initialize(app)
      @app = app
    end

    # noinspection RubyArgCount
    def call(env)
      status, header, response = @app.call(env)

      json_response = JSON.parse(response.last)

      nav_opts = []
      json_response.fetch('navigation', {}).sort.each do |k, v|
        nav_opts << "#{k} #{v['label']}" if v.fetch('label')
      end

      message = json_response['message']

      if json_response['notice']
        message = [json_response['notice'], message].join("\n\n")
        json_response.delete 'notice'
      end

      json_response['message'] = [message, nav_opts].flatten.compact.join("\n")
      body = json_response.to_json.to_s
      header['Content-Length'] = body.length.to_s
      return status, header, [body]
    end
  end
end