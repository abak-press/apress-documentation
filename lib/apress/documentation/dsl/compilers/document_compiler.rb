require_relative 'base_compiler'
require_relative '../utils/swagger_bind_point_extractor'
require_relative './mixins/dependable'
require_relative './mixins/publicity'

module Apress
  module Documentation
    module Dsl
      module Compilers
        # Private: "Компилирует" блок для объекта класса Document заполняя в нем нужные аттрибуты
        class DocumentCompiler < BaseCompiler
          include Apress::Documentation::Dsl::Mixins::Dependable
          include Apress::Documentation::Dsl::Mixins::Publicity
          setters :title,
                  :description,
                  :business_desc,
                  :tests

          # Public: метод DSL, Создает документ, осуществляет вложеность документов
          #
          # slug - (required), String or Symbol - слаг документа
          # fields - Hash - позволяет задавать поля через хеш
          # block - Proc - DSL для настройки полей документа
          #
          #  Examples
          #
          #    Apress::Documentation.build(:module) do
          #      document(:html) do
          #        description 'Описывает все HTMl старницы'
          #        document(:page) do
          #          description 'Тут описание только одной'
          #        end
          #      end
          #    end
          #
          #    Можно вызывать без блока
          #    Apress::Documentation.build(:module) do
          #      document :name, title: :test, description: 'some description'
          #    end
          def document(slug, fields = {}, &block)
            slug = slug.to_s
            doc = target.documents[slug]
            doc ||= Apress::Documentation::Storage::Document.new(target.slug + '/' + slug)
            Storage::DependencyGraph.instance.add_document(doc)

            target.documents[slug] = doc
            doc.compile(fields, &block)
          end

          # Public: метод DSL, Создает swagger-описание внутри документа.
          #
          # slug - (required), String or Symbol - слаг документа
          # fields - Hash - позволяет задавать поля через хеш
          # block - Proc - DSL для настройки полей документа
          #
          # Examples
          #
          #   Apress::Documentation.build(:module) do
          #     document(:http_api) do
          #       description 'Описывает все API модуля'
          #       swagger_bind('tag_operationId_content') do
          #         description 'Тут описание только одной'
          #         swagger_path('api/docs') do
          #            # Тут вызовы методов Swagger::Blocks
          #         end
          #       end
          #     end
          #   end
          #
          #   Можно вызывать без указания html_id,
          #   тогда он будет "распознан" из блока автоматически, если это возможно.
          #   В случае если html_id не был передан и "распознать" html_id невозможно, будет кинуто исключение.
          #
          #   Детали "распознования" см. в Apress::Documentation::Dsl::Utils::SwaggerBindPointExtractor
          #
          #   Apress::Documentation.build(:module) do
          #     document(:http_api) do
          #       description 'Описывает все API модуля'
          #       swagger_bind do                        # -> будет tag_operationId_content
          #         description 'Тут описание только одной'
          #         swagger_path('api/docs') do
          #           operation :get do
          #              key :operationId, 'operationId' # -> обязательный вызов для распознавания
          #              key :tags, ['tag']              # -> обязательный вызов для распознавания
          #           end
          #         end
          #       end
          #     end
          #   end
          def swagger_bind(html_id = nil, fields = {}, &block)
            html_id = recognize_html_id(html_id, &block)
            doc = target.swagger_documents[html_id]
            doc ||= Apress::Documentation::Storage::SwaggerDocument.new(target, html_id)
            Storage::DependencyGraph.instance.add_document(doc)

            target.swagger_documents[html_id] = doc
            doc.compile(fields, &block)
          end

          private

          def recognize_html_id(html_id, &block)
            html_id ||= Apress::Documentation::Dsl::Utils::SwaggerBindPointExtractor.new.extract(&block)
            raise "Could not recognize html_id from block" unless html_id
            html_id.to_s
          end
        end
      end
    end
  end
end
