# frozen_string_literal: true

module KlaviyoAPI
  class Configuration
    attr_accessor :url

    def initialize
      # base url
      @url = 'https://a.klaviyo.com/api/'
    end
  end

  class << self
    def configure
      yield configuration

      KlaviyoAPI::Base.site = configuration.url

      configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
