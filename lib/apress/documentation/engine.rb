module Apress
  module Documentation
    class Engine < Rails::Engine
      config.autoload_paths += [
        config.root.join('app', 'controllers', 'concerns')
      ]
      config.paths.add 'app/docs', eager_load: false

      ActiveSupport.on_load(:documentation) do
        glob = Apress::Documentation::Engine.config.root.join('app/docs/**/*.rb')
        Dir[glob].each { |file| require file }
      end
    end
  end
end
