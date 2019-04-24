# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::Event do
  METRIC_ID = 'metricId'
  SINGLE_METRIC_EVENTS_BASE_URL = "https://a.klaviyo.com/api/v1/metric/#{METRIC_ID}/timeline"
  ALL_METRICS_EVENTS_BASE_URL = "https://a.klaviyo.com/api/v1/metrics/timeline"

  before do
    stub_request(:get, %r{#{SINGLE_METRIC_EVENTS_BASE_URL}})
      .to_return body: load_fixture(:single_metric_events)

    stub_request(:get, %r{#{ALL_METRICS_EVENTS_BASE_URL}})
      .to_return body: load_fixture(:all_metrics_events)
  end

  it 'instantiates proper class' do
    metrics = KlaviyoAPI::Event.all

    assert_kind_of KlaviyoAPI::Collections::NextMarkerCollection, metrics
    assert_instance_of KlaviyoAPI::Event, metrics.first
  end

  describe 'collection_path' do
    it 'adds API key as query param' do
      KlaviyoAPI::Session.temp('my_key') do
        assert_match %r{\?api_key=my_key}, KlaviyoAPI::Event.collection_path
      end
    end

    it 'returns path for specific Metric timeline if Metric ID given' do
      assert_match %r{/api/v1/metric/#{METRIC_ID}/timeline}, KlaviyoAPI::Event.collection_path({metric_id: METRIC_ID})
    end

    it 'returns path for all Metrics timelines if no Metric ID given' do
      assert_match %r{/api/v1/metrics/timeline}, KlaviyoAPI::Event.collection_path
    end
  end

  describe 'find_single' do
    it 'raise InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::Event.find 'abc'
      end

      assert_match 'Cannot get single Event via API. Please use KlaviyoAPI::Event#all.', error.message
    end
  end

  describe 'destroy' do
    it 'raises InvalidOperation' do
      profile = KlaviyoAPI::Event.all[0]

      error = assert_raises KlaviyoAPI::InvalidOperation do
        profile.destroy
      end

      assert_match 'Cannot delete Events via API.', error.message
    end
  end

  describe 'create' do
    it 'raises InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::Event.create
      end

      assert_match 'Cannot create Events via API.', error.message
    end
  end

  describe 'update' do
    it 'raises InvalidOperation' do
      error = assert_raises KlaviyoAPI::InvalidOperation do
        KlaviyoAPI::Event.all[0].save
      end

      assert_match 'Cannot update Events via API.', error.message
    end
  end
end
