require 'spec_helper'

describe Sinatra::Ussd do
  before do
    mock_app do
      register Sinatra::Ussd::Base

      post '/new' do
        {
            'message' => 'welcome to ussd app\n1 greet',
            'response_map' => {
                '1' => '/greet'
            }
        }.to_json
      end

      post '/greet' do
        {
            'message' => 'Enter Name',
            'response_map' => {
              'text_input' => '/welcome'
            }
        }.to_json
      end

      post '/welcome' do
        {
            'message' => "Welcome #{message}\n* Back"
        }.to_json
      end
    end
  end

  it 'should message' do
    response = post('/ussd/default/index', {'msisdn' => '2345678', 'session' => 'new', 'session_id' => '12334', 'message' => '1'}.to_json)

    json_response = JSON.parse(response.body)
    expect(json_response).to eq({'message' => "welcome to ussd app\\n1 greet", 'response' => {'message' => "welcome to ussd app\\n1 greet", 'response_map' => {'1' => '/greet'}}, 'session_id' => '12334', 'session' => 'continue', 'msisdn' => '2345678'})


    response = post('/ussd/default/index', {'msisdn' => '2345678', 'session' => 'continue', 'session_id' => '12334', 'message' => '1'}.to_json)


    json_response = JSON.parse(response.body)
    expect(json_response).to eq({"message"=>"Enter Name", "response"=>{"message"=>"Enter Name", "response_map"=>{"text_input"=>"/welcome"}}, "session_id"=>"12334", "session"=>"continue", "msisdn"=>"2345678"})


    response = post('/ussd/default/index', {'msisdn' => '2345678', 'session' => 'continue', 'session_id' => '12334', 'message' => 'Clarke Kent'}.to_json)


    json_response = JSON.parse(response.body)
    expect(json_response).to eq({"message"=>"Welcome Clarke Kent\n* Back", "response"=>{"message"=>"Welcome Clarke Kent\n* Back"}, "session_id"=>"12334", "session"=>"continue", "msisdn"=>"2345678"})

  end
end
