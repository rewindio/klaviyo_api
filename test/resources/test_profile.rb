# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Profile do
  BASE_PROFILE_URL = 'https://a.klaviyo.com/api/v1'
  PERSON_ID = 'personId'

  before do
    stub_request(:get, %r{#{BASE_PROFILE_URL}\/people})
      .to_return body: load_fixture(:people)

    stub_request(:get, %r{#{BASE_PROFILE_URL}\/person\/#{PERSON_ID}})
      .to_return body: load_fixture(:person)
  end

  it 'instantiates proper class' do
    profiles = KlaviyoAPI::Profile.all

    assert_kind_of KlaviyoAPI::Collections::Profile, profiles
    assert_instance_of KlaviyoAPI::Profile, profiles.first
  end

  describe 'collection_path' do
    it 'uses people' do
      assert_match %r{\/api\/v1\/people}, KlaviyoAPI::Profile.collection_path
    end

    it 'adds API key as query param' do
      KlaviyoAPI::Session.temp('my_key') do
        assert_match %r{\?api_key=my_key}, KlaviyoAPI::Profile.collection_path
      end
    end
  end

  describe 'element_path' do
    it 'uses person' do
      assert_match %r{\/api\/v1\/person\/#{PERSON_ID}}, KlaviyoAPI::Profile.element_path(PERSON_ID)
    end

    it 'adds API key as query param' do
      KlaviyoAPI::Session.temp('my_key') do
        assert_match %r{\?api_key=my_key}, KlaviyoAPI::Profile.element_path(PERSON_ID)
      end
    end
  end

  describe 'destroy' do
    it 'raises InvalidOperation' do
      profile = KlaviyoAPI::Profile.first

      error = assert_raises KlaviyoAPI::InvalidOperation do
        profile.destroy
      end

      assert_match 'Cannot delete Profiles via API.', error.message
    end
  end

  describe 'create' do
    it 'raises InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::Profile.create
      end

      assert_match 'Cannot create Profiles via API.', error.message
    end
  end

  describe 'update' do
    it 'adds all attributes to the URL' do
      stub_request(:put, "#{BASE_PROFILE_URL}/person/#{PERSON_ID}?$title=MyTitle&api_key=&id=#{PERSON_ID}")
        .to_return body: load_fixture(:person)

      profile = KlaviyoAPI::Profile.new id: PERSON_ID, '$title': 'MyTitle'

      profile.update

      assert_requested :put, "#{BASE_PROFILE_URL}/person/#{PERSON_ID}?$title=MyTitle&api_key=&id=#{PERSON_ID}", body: nil
    end
  end

  describe 'method_missing' do
    it 'is aware of attributes starting with $' do
      profile = KlaviyoAPI::Profile.new '$title': 'MyTitle'

      assert_equal 'MyTitle', profile.title
      profile.title = 'YourTitle'
      assert_equal 'YourTitle', profile.title
    end

    it 'is aware of attributes NOT starting with $' do
      profile = KlaviyoAPI::Profile.new 'last_name': 'McTesterson'

      assert_equal 'McTesterson', profile.last_name
      profile.last_name = 'McTesterson2'
      assert_equal 'McTesterson2', profile.last_name
    end

    it 'prioritizes attributes starting with $' do
      profile = KlaviyoAPI::Profile.new 'title': 'MyTitle', '$title': '$MyTitle'

      assert_equal '$MyTitle', profile.title
      profile.title = '$YourTitle'
      assert_equal '$YourTitle', profile.title

      assert_equal 'MyTitle', profile.attributes['title']
      assert_equal '$YourTitle', profile.attributes['$title']
    end
  end
end
