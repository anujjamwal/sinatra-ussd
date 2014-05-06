require 'spec_helper'

describe Sinatra::Ussd::Caching do
  let(:cache_store) {Sinatra::Ussd::HashStore.instance}
  let(:session_id) {'kuoabioebc498g2093gr4fv932f223232'}
  let(:caching) {Sinatra::Ussd::Caching.new(cache_store)}

  it 'should populate request from cache' do
    cache_store.set(session_id, {'response' => {}}.to_json)
    request = {'message' => '1234', 'session_id' => session_id}

    populated_request = caching.populate_request(request)

    expect(populated_request).to eq({'message' => '1234', 'session_id' => session_id, 'response' => {}})
  end

  it 'should not fail if key not found in store' do
    cache_store.set("#{session_id}4444", {'response' => {}}.to_json)
    request = {'message' => '1234', 'session_id' => session_id}

    populated_request = caching.populate_request(request)

    expect(populated_request).to eq({'message' => '1234', 'session_id' => session_id})
  end

  it 'should cache response' do
    cache_store
    response = {'response' => {'message' => '1234'}, 'session_id' => session_id}

    caching.cache_response(response)

    expect(JSON.parse(cache_store.get(session_id))).to eq({'response' => {'message' => '1234', }})
  end
end