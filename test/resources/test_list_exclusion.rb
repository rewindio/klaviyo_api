# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::ListExclusion do
  LIST_EXCLUSIONS_URL = 'https://a.klaviyo.com/api/v2/list/l1234/exclusions/all'

  before do
    stub_request(:get, %r{#{LIST_EXCLUSIONS_URL}})
      .to_return body: load_fixture(:list_exclusions)
  end

  it 'instantiates proper class' do
    exclusions = KlaviyoAPI::ListExclusion.all params: { list_id: 'l1234' }

    assert_kind_of KlaviyoAPI::Collections::MarkerCollection, exclusions
    assert_instance_of KlaviyoAPI::ListExclusion, exclusions.first
  end

  describe 'find_single' do
    it 'raise InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::ListExclusion.find 'abc'
      end

      assert_match 'Cannot get single Exclusion via API. Please use KlaviyoAPI::ListExclusion#all.', error.message
    end
  end

  describe 'destroy' do
    it 'raises InvalidOperation' do
      profile = KlaviyoAPI::ListExclusion.all(params: { list_id: 'l1234' })[0]

      error = assert_raises KlaviyoAPI::InvalidOperation do
        profile.destroy
      end

      assert_match 'Cannot delete ListExclusions via API.', error.message
    end
  end

  describe 'create' do
    it 'raises InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::ListExclusion.create
      end

      assert_match 'Cannot create ListExclusions via API.', error.message
    end
  end

  describe 'update' do
    it 'raises InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::ListExclusion.all(params: { list_id: 'l1234' })[0].save
      end

      assert_match 'Cannot update ListExclusions via API.', error.message
    end
  end
end
