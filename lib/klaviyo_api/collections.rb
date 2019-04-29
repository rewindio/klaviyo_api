# frozen_string_literal: true

require 'klaviyo_api/collections/paginated_collection'
require 'klaviyo_api/collections/marker_collection'

Dir.glob("#{File.dirname(__FILE__)}/collections/*").each { |file| require file if file.end_with? '.rb' }
