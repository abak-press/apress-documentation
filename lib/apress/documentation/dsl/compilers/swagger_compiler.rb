require_relative 'base_compiler'
require_relative './mixins/dependable'
require_relative './mixins/publicity'

module Apress
  module Documentation
    module Dsl
      module Compilers
        # Private: "Компилирует" блок для объекта класса SwaggerDocument заполняя в нем нужные аттрибуты
        class SwaggerCompiler < BaseCompiler
          include Apress::Documentation::Dsl::Mixins::Dependable
          include Apress::Documentation::Dsl::Mixins::Publicity
          extend Forwardable

          alias_method :swagger_document, :target
          setters :business_desc,
                  :tests

          def_delegators :swagger_document, :swagger_class
          def_delegators :swagger_class, :swagger_path
        end
      end
    end
  end
end
