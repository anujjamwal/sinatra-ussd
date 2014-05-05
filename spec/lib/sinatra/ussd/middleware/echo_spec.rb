require 'spec_helper'

describe Sinatra::Ussd::Middleware::Echo do
  before do
    mock_app do
      use Sinatra::Ussd::Middleware::Echo, Sinatra::Ussd::Caching.new

      post '/' do
        request.body.read
      end
    end
  end

  it 'should populate request and cache response' do
    request_body = {
        'message' => '1'
    }

    Sinatra::Ussd::Caching.any_instance.should_receive(:populate_request).and_return({'message' => '1', 'message2' => '2'})
    Sinatra::Ussd::Caching.any_instance.should_receive(:cache_response)
    response = post('/', request_body.to_json)

    expect(JSON.parse(response.body)).to eq({'message' => '1', 'message2' => '2'})
  end
end