require 'spec_helper'

describe Sinatra::Ussd::Middleware::Facade do
  before do
    mock_app do
      use Sinatra::Ussd::Middleware::Facade
    end
  end

  it 'should route to the url by finding url from options' do
    default_adapter_mock = double(Sinatra::Ussd::Adapter::Default)
    Sinatra::Ussd::Adapter.should_receive(:get).with('default').and_return(Sinatra::Ussd::Adapter::Default)
    Sinatra::Ussd::Adapter::Default.stub(new: default_adapter_mock)
    default_adapter_mock.should_receive(:call).and_return([200, {}, []])

    post('/ussd/default/index', {}.to_json)
  end

  it 'should return error if adapter not found' do
    response = post('/ussd/no_adapter/index', {}.to_json)

    expect(response.status).to be(400)
  end
end