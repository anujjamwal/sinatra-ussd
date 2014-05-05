require 'spec_helper'

describe Sinatra::Ussd::Middleware::Dispatcher do
  before do
    mock_app do
      use Sinatra::Ussd::Middleware::Dispatcher

      post '/my_url' do
        {url: '/my_url_post'}.to_json
      end

      post '/new' do
        {url: '/new'}.to_json
      end

      post '*' do
        {url: '/not_my_url'}.to_json
      end
    end
  end

  it 'should route to the url by finding url from options' do
    request = {
        'message' => '0',
        'msisdn' => '345678',
        'session' => 'continue',
        'session_id' => 'session_id',
        'response' => {
            'response_map' => {
                '0' => '/my_url'
            }
        }
    }

    response = post('/', request.to_json)

    expect(JSON.parse(response.body)).to eq({"response"=>{"url"=>"/my_url_post"}, "session_id"=>"session_id", "session"=>"continue", "msisdn"=>"345678"})
  end

  it 'should route to /new url if session is new' do
    request = {
        'message' => '0',
        'session' => 'new',
        'response' => {
            'response_map' => {
                '0' => '/my_url'
            }
        }
    }

    response = post('/', request.to_json)

    expect(JSON.parse(response.body)).to eq({"response"=>{"url"=>"/new"}, "session_id"=>nil, "session"=>"continue", "msisdn"=>nil})
  end
end