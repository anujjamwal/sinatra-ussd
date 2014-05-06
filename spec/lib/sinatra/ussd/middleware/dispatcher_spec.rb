require 'spec_helper'

describe Sinatra::Ussd::Middleware::Dispatcher do
  before do
    mock_app do
      use Sinatra::Ussd::Middleware::Dispatcher

      post '/my_url' do
        {message: '/my_url_post'}.to_json
      end

      post '/my_url2' do
        {message: '/my_url_post2'}.to_json
      end

      post '/new' do
        {message: '/new'}.to_json
      end

      post '*' do
        {message: '/not_my_url'}.to_json
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

    expect(JSON.parse(response.body)).to eq({"response"=>{"message"=>"/my_url_post"}, "session_id"=>"session_id", "session"=>"continue", "msisdn"=>"345678", "message"=>"/my_url_post"})
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

    expect(JSON.parse(response.body)).to eq({"response"=>{"message"=>"/new"}, "message"=>"/new", "session_id"=>nil, "session"=>"continue", "msisdn"=>nil})
  end

  it 'should resolve text input url' do
    request = {
        'message' => 'any text',
        'session' => 'continue',
        'response' => {
            'response_map' => {
                'text_input' => '/my_url'
            }
        }
    }

    response = post('/', request.to_json)

    expect(JSON.parse(response.body)).to eq({"response"=>{"message"=>"/my_url_post"}, "message"=>"/my_url_post", "session_id"=>nil, "session"=>"continue", "msisdn"=>nil})
  end

  it 'should resolve to input if corresponding choice present in options' do
    request = {
        'message' => '0',
        'session' => 'continue',
        'response' => {
            'response_map' => {
                '0' => '/my_url',
                'text_input' => '/my_url2'
            }
        }
    }

    response = post('/', request.to_json)

    expect(JSON.parse(response.body)).to eq({"response"=>{"message"=>"/my_url_post"}, "message"=>"/my_url_post", "session_id"=>nil, "session"=>"continue", "msisdn"=>nil})
  end
end