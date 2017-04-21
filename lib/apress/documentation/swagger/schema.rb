module Apress
  module Documentation
    module Swagger
      class Schema
        include ::Swagger::Blocks

        def self.swagger_path_with_docs(*args, &block)
          self.resource = true
          swagger_path_without_docs(*args, &block)
        end

        def self.swagger_schema_with_docs(*args, &block)
          self.schema_block = block
          swagger_schema_without_docs(*args, &block)
        end

        class << self
          alias_method_chain :swagger_schema, :docs
          alias_method_chain :swagger_path, :docs

          attr_accessor :resource, :document_slug, :schema_block
        end

        def self.schema_name(name)
          "#{self.name}::#{name.to_s.camelize}".to_sym
        end

        def self.swagger_classes
          @swagger_classes ||= []
        end

        def self.inherited(child)
          swagger_classes << child
        end
      end
    end
  end
end
