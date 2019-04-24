# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Metric do
  BASE_METRIC_URL = 'https://a.klaviyo.com/api/v1'
  METRIC_ID = 'metricId'

  before do
    stub_request(:get, %r{#{BASE_METRIC_URL}\/metrics})
      .to_return body: load_fixture(:metrics)
  end

  it 'instantiates proper class' do
    metrics = KlaviyoAPI::Metric.all

    assert_kind_of KlaviyoAPI::Collections::PaginatedCollection, metrics
    assert_instance_of KlaviyoAPI::Metric, metrics.first
  end

  describe 'collection_path' do
    it 'adds API key as query param' do
      KlaviyoAPI::Session.temp('my_key') do
        assert_match %r{\?api_key=my_key}, KlaviyoAPI::Metric.collection_path
      end
    end
  end

  describe 'find_single' do
    it 'raise InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::Metric.find METRIC_ID
      end

      assert_match 'Cannot get single Metric via API. Please use KlaviyoAPI::Metric#all.', error.message
    end
  end

  describe 'destroy' do
    it 'raises InvalidOperation' do
      profile = KlaviyoAPI::Metric.all[0]

      error = assert_raises KlaviyoAPI::InvalidOperation do
        profile.destroy
      end

      assert_match 'Cannot delete Metrics via API.', error.message
    end
  end

  describe 'create' do
    it 'raises InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::Metric.create
      end

      assert_match 'Cannot create Metrics via API.', error.message
    end
  end

  describe 'update' do
    it 'raises InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::Metric.all[0].save
      end

      assert_match 'Cannot update Metrics via API.', error.message
    end
  end
end
