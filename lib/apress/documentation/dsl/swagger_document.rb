require_relative 'compilers/swagger_compiler'

module Apress
  module Documentation
    module Dsl
      module SwaggerDocument
        # Public: Подключает DSL в класс данных swagger-описания
        def compile(fields = {}, &block)
          Apress::Documentation::Dsl::Compilers::SwaggerCompiler.new(self).compile(fields, &block)
        end
      end
    end
  end
end
