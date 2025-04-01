module TrixGenius
  class << self
    attr_accessor :deepseek_api_key

    def configure
      yield self
    end
  end
end
