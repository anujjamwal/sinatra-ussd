require 'spec_helper'

describe Sinatra::Ussd::Adapter do
  it 'should return the adapter for the passed aggregator id' do
    expect(Sinatra::Ussd::Adapter.get('default')).to be(Sinatra::Ussd::Adapter::Default)
  end

  it 'should return exception if the adapter not found for given aggregator' do
    expect(Sinatra::Ussd::Adapter.get('no_adapter_of_form')).to be(nil)
  end
end