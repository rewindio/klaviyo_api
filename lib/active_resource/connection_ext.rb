# frozen_string_literal: true

require 'klaviyo_api/connection'

module ActiveResource
  class Connection
    attr_reader :response

    prepend KlaviyoAPI::Connection::ResponseCapture
    prepend KlaviyoAPI::Connection::RequestNotification
  end
end
