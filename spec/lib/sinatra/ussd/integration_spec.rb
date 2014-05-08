require 'spec_helper'

describe Sinatra::Ussd do
  before do
    mock_app do
      register Sinatra::Ussd::Base

      post '/new' do
        {
            'message' => 'welcome to ussd app',
            'navigation' => {
                '1' => {'url' => '/greet', 'label' => 'greet'}
            }
        }.to_json
      end

      post '/greet' do
        {
            'message' => 'Enter Name',
            'navigation' => {
              'text_input' => {'url' => '/welcome', 'label' => nil}
            }
        }.to_json
      end

      post '/welcome' do
        {
            'message' => "Welcome #{message}"
        }.to_json
      end
    end
  end

  it 'should message' do
    response = post('/ussd/default/index', {'msisdn' => '2345678', 'session' => 'new', 'session_id' => '12334', 'message' => '1'}.to_json)

    json_response = JSON.parse(response.body)
    expect(json_response).to eq({"message"=>"welcome to ussd app\n1 greet", "navigation"=>{"1"=>{"url"=>"/greet", "label"=>"greet"}}, "response"=>{"message"=>"welcome to ussd app", "navigation"=>{"1"=>{"url"=>"/greet", "label"=>"greet"}}}, "session_id"=>"12334", "session"=>"continue", "msisdn"=>"2345678"})


    response = post('/ussd/default/index', {'msisdn' => '2345678', 'session' => 'continue', 'session_id' => '12334', 'message' => '1'}.to_json)


    json_response = JSON.parse(response.body)
    expect(json_response).to eq({"message"=>"Enter Name", "navigation"=>{"text_input"=>{"url"=>"/welcome", "label"=>nil}}, "response"=>{"message"=>"Enter Name", "navigation"=>{"text_input"=>{"url"=>"/welcome", "label"=>nil}}}, "session_id"=>"12334", "session"=>"continue", "msisdn"=>"2345678"})


    response = post('/ussd/default/index', {'msisdn' => '2345678', 'session' => 'continue', 'session_id' => '12334', 'message' => 'Clarke Kent'}.to_json)


    json_response = JSON.parse(response.body)
    expect(json_response).to eq({"message"=>"Welcome Clarke Kent", "response"=>{"message"=>"Welcome Clarke Kent"}, "session_id"=>"12334", "session"=>"continue", "msisdn"=>"2345678"})
  end

  it 'should return invalid option with previous message if message not found in response map' do
    response = post('/ussd/default/index', {'msisdn' => '2345678', 'session' => 'new', 'session_id' => '12334', 'message' => '1'}.to_json)

    json_response = JSON.parse(response.body)
    expect(json_response).to eq({"message"=>"welcome to ussd app\n1 greet", "navigation"=>{"1"=>{"url"=>"/greet", "label"=>"greet"}}, "response"=>{"message"=>"welcome to ussd app", "navigation"=>{"1"=>{"url"=>"/greet", "label"=>"greet"}}}, "session_id"=>"12334", "session"=>"continue", "msisdn"=>"2345678"})


    response = post('/ussd/default/index', {'msisdn' => '2345678', 'session' => 'continue', 'session_id' => '12334', 'message' => '4'}.to_json)


    json_response = JSON.parse(response.body)
    expect(json_response).to eq({"message"=>"Invalid Option\n\nwelcome to ussd app\n1 greet", "navigation"=>{"1"=>{"url"=>"/greet", "label"=>"greet"}}, "response"=>{"message"=>"welcome to ussd app", "navigation"=>{"1"=>{"url"=>"/greet", "label"=>"greet"}}}, "session_id"=>"12334", "session"=>"continue", "msisdn"=>"2345678"})
  end
end
