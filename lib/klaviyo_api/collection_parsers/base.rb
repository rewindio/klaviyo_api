# frozen_string_literal: true

module KlaviyoAPI::CollectionParsers
  class Base < ActiveResource::Collection
    def initialize(response = {})
      @elements = [] if response.is_a? Array
    end
  end
end
