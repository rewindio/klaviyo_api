# frozen_string_literal: true

Dir.glob("#{File.dirname(__FILE__)}/collections/*").each { |file| require file if file.end_with? '.rb' }
