# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Base do
  before do
    KlaviyoAPI::Base.reset_session
  end

  after do
    KlaviyoAPI::Base.reset_session
  end

  it 'properly initializes the headers' do
    assert_equal "KlaviyoAPI/#{KlaviyoAPI::VERSION}", KlaviyoAPI::Base.headers['User-Agent']
    assert_equal 'application/json', KlaviyoAPI::Base.headers['Accept']
    assert_nil KlaviyoAPI::Base.headers['api-key']
  end

  it 'actives a session' do
    assert_equal KlaviyoAPI::Base.site.to_s, KlaviyoAPI.configuration.url

    session = KlaviyoAPI::Session.new 'pk_xxxyyyzzz'

    KlaviyoAPI::Base.activate_session session

    assert_equal KlaviyoAPI::Base.headers['api-key'], session.api_key.to_s
  end

  it 'resets a session' do
    session = KlaviyoAPI::Session.new 'pk_xxxyyyzzz'

    KlaviyoAPI::Base.activate_session session

    assert_equal KlaviyoAPI::Base.headers['api-key'], session.api_key.to_s

    KlaviyoAPI::Base.reset_session

    assert_nil KlaviyoAPI::Base.headers['api-key']
    assert_equal KlaviyoAPI::Base.site.to_s, KlaviyoAPI.configuration.url
  end

  describe 'exists' do
    it 'returns false if item not found' do
      stub_request(:get, 'https://a.klaviyo.com/v2/bases/123?fields=id')
        .to_return status: 404

      assert_equal false, KlaviyoAPI::Base.exists?(123)
    end

    it 'returns true if item found' do
      stub_request(:get, 'https://a.klaviyo.com/v2/bases/123?fields=id')
        .to_return status: 200, body: '{}'

      assert_equal true, KlaviyoAPI::Base.exists?(123)
    end
  end
end
