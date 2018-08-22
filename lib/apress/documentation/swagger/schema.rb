module Apress
  module Documentation
    module Swagger
      class Schema
        include ::Swagger::Blocks

        class << self
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

        module Extensions
          def swagger_path(*args, &block)
            self.resource = true
            super
          end

          def swagger_schema(*args, &block)
            self.schema_block = block
            super
          end
        end

        singleton_class.prepend Extensions
      end
    end
  end
end
