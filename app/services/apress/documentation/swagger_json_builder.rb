module Apress
  module Documentation
    class SwaggerJsonBuilder
      def initialize(module_name)
        @module_name = module_name
      end

      def call
        classes =
          if @module_name
            Apress::Documentation::Swagger::Schema.swagger_classes.select do |klass|
              klass.document_slug.to_s == @module_name.to_s || !klass.resource
            end
          else
            Apress::Documentation::Swagger::Schema.swagger_classes
          end

        ::Swagger::Blocks.build_root_json(classes)
      end
    end
  end
end
