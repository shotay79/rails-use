# frozen_string_literal: true

require_relative '../slack_notifier'
require_relative "use/version"
require_relative "use/railsroutes2aspida"
require_relative "use/railsserializer2schema"

module Rails
  module Use
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
end
