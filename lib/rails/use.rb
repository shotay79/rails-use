# frozen_string_literal: true

require_relative "use/version"
require_relative "use/railsroutes2aspida"
require_relative "use/railsserializer2schema"

module Rails
  module Use
    class Error < StandardError; end
    # Your code goes here...
  end
end
