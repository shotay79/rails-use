# frozen_string_literal: true

require_relative 'slack_notifier'
require_relative "rails_use/version"
require_relative "rails_use/railsroutes2aspida"
require_relative "rails_use/railsserializer2schema"

module RailsUse
  class Error < StandardError; end
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
