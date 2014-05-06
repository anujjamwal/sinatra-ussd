require 'spec_helper'

describe Sinatra::Ussd::Middleware::Echo do
  before do
    mock_app do
      use Sinatra::Ussd::Middleware::MessageBuilder

      post '/notice' do
        {
            'notice' => 'Notice',
            'message' => 'This is a message'
        }.to_json
      end

      post '/no_notice' do
        {
            'message' => 'This is a message'
        }.to_json
      end
    end
  end

  it 'should join notice and message' do
    response = post('/notice', {}.to_json)

    expect(JSON.parse(response.body)).to eq({"message"=>"Notice\n\nThis is a message"})
  end

  it 'should not change message if notice not present' do
    response = post('/no_notice', {}.to_json)

    expect(JSON.parse(response.body)).to eq({"message"=>"This is a message"})
  end
end