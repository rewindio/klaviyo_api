# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::ProfileExclusion do
  BASE_PROFILE_URL = 'https://a.klaviyo.com/api/v1'

  before do
    stub_request(:get, "#{BASE_PROFILE_URL}/people/exclusions?api_key=")
      .to_return body: load_fixture(:profile_exclusions_1)
    stub_request(:get, "#{BASE_PROFILE_URL}/people/exclusions?api_key=&page=1")
      .to_return body: load_fixture(:profile_exclusions_2)
  end

  it 'instantiates proper class' do
    exclusions = KlaviyoAPI::ProfileExclusion.all

    assert_kind_of KlaviyoAPI::Collections::PaginatedCollection, exclusions
    assert_instance_of KlaviyoAPI::ProfileExclusion, exclusions.first
  end

  it 'makes pagination requests' do
    exclusions_page_two = KlaviyoAPI::ProfileExclusion.all params: { page: 1 }

    assert_equal exclusions_page_two.first.email, 'news2@test.com'
  end

  describe 'collection_path' do
    it 'uses people' do
      assert_match %r{\/api\/v1\/people\/exclusions}, KlaviyoAPI::ProfileExclusion.collection_path
    end

    it 'adds API key as query param' do
      KlaviyoAPI::Session.temp('my_key') do
        assert_match %r{\?api_key=my_key}, KlaviyoAPI::ProfileExclusion.collection_path
      end
    end
  end

  describe 'create' do

    before do
      stub_request(:post, "#{BASE_PROFILE_URL}/people/exclusions?api_key=")
    end

    it 'calls api' do
      KlaviyoAPI::ProfileExclusion.create email: 'something@asdf.com'

      assert_requested(:post,
                       "#{BASE_PROFILE_URL}/people/exclusions?api_key=",
                       body: { email: 'something@asdf.com' })
    end
  end
end
