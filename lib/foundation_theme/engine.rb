module FoundationTheme
  class Engine < ::Rails::Engine
    # isolate_namespace FoundationTheme
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../lib/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
