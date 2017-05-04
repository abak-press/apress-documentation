module Apress
  module Documentation
    class Engine < Rails::Engine
      config.autoload_paths += [
        config.root.join('app', 'controllers', 'concerns')
      ]
    end
  end
end
