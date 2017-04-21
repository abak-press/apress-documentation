require_relative 'base_compiler'

module Apress
  module Documentation
    module Dsl
      module Compilers
        # Private: "Компилирует" блок для объекта класса SwaggerDocument заполняя в нем нужные аттрибуты
        class SwaggerCompiler < BaseCompiler
          extend Forwardable

          alias_method :swagger_document, :target
          setters :business_desc,
                  :publicity,
                  :tests,
                  :consumers

          def_delegators :swagger_document, :swagger_class
          def_delegators :swagger_class, :swagger_path
        end
      end
    end
  end
end
