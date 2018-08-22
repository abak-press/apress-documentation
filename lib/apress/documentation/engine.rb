module Apress
  module Documentation
    class Engine < Rails::Engine
      config.autoload_paths += [
        config.root.join('app', 'controllers', 'concerns'),
        config.root.join('app', 'presenters')
      ]

      config.documentation = {path_scope: nil, routes_constraints: {domain: :current}}

      initializer "apress-documentation", before: :load_init_rb do |app|
        RGL::DirectedAdjacencyGraph.include Apress::Documentation::Extensions::RGL::Adjacency
      end
    end
  end
end
