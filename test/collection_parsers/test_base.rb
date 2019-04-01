# frozen_string_literal: true

require 'test_helper'

describe KlaviyoAPI::CollectionParsers::Base do
  before do
    json_formatter  = KlaviyoAPI::JsonFormatter.new nil
    @decoded_json   = json_formatter.decode load_fixture(:lists)
  end

  it 'valid initialization' do
    collection = KlaviyoAPI::CollectionParsers::List.new @decoded_json

    assert_equal collection.count, 3

    assert_kind_of Array, collection.instance_variable_get(:@elements)
  end

  it 'has the proper element key' do
    collection = KlaviyoAPI::CollectionParsers::Base.new

    assert_equal collection.send(:element_key), 'bases'
  end
end
