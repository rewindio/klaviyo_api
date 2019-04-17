# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)

# gem requires
require 'activeresource'
require 'caching_enumerator'

# gem extensions
require 'active_resource/connection_ext'

require 'klaviyo_api/version'
require 'klaviyo_api/configuration'

module KlaviyoAPI
end

require 'klaviyo_api/json_formatter'
require 'klaviyo_api/connection'
require 'klaviyo_api/detailed_log_subscriber'
require 'klaviyo_api/exceptions'
require 'klaviyo_api/session'

require 'klaviyo_api/collections'
require 'klaviyo_api/resources'
