# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::JsonFormatter do
  it 'initializes properly' do
    json_formatter = KlaviyoAPI::JsonFormatter.new 'CollectionName'

    assert_kind_of String, json_formatter.instance_variable_get(:@collection_name)
    assert_equal   'CollectionName', json_formatter.instance_variable_get(:@collection_name)
  end

  it 'successfully decodes json' do
    json_formatter = KlaviyoAPI::JsonFormatter.new nil

    decoded_json = json_formatter.decode load_fixture(:lists)

    assert_kind_of Array, decoded_json
    assert_equal decoded_json.count, 3
  end
end
