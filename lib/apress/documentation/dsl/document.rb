require_relative 'compilers/document_compiler'

module Apress
  module Documentation
    module Dsl
      module Document
        # Public: Подключает DSL в класс данных документа
        def compile(fields = {}, &block)
          Apress::Documentation::Dsl::Compilers::DocumentCompiler.new(self).compile(fields, &block)
        end
      end
    end
  end
end
