# frozen_string_literal: true

module KlaviyoAPI
  class Session
    attr_accessor :api_key

    def initialize(api_key)
      self.api_key = api_key
    end

    class << self
      def temp(api_key)
        session = new api_key

        KlaviyoAPI::Base.activate_session session

        yield
      ensure
        KlaviyoAPI::Base.reset_session
      end
    end
  end
end
