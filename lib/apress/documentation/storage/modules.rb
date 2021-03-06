require 'singleton'
require_relative '../dsl/modules'

module Apress
  module Documentation
    module Storage
      # Protected
      #
      # Класс хранения документов верхнего уровня (модулей)
      class Modules
        include Apress::Documentation::Dsl::Modules
        include Singleton

        # Public
        #
        # Хеш модулей
        def data
          @data ||= {}
        end

        # Public
        #
        # Добавление модуля
        #
        # Arguments
        #   document - Document
        #
        # Example usage:
        #   Apress::Documentation::Modules.instance << document
        def <<(document)
          data[document.slug.to_s] = document
        end

        # Public
        #
        # Поиск модуля
        #
        # Arguments
        #   slug - String (или любой совместимый объект) - слаг документа
        #
        # Example usage:
        #   Apress::Documentation::Modules.instance[slug]
        #
        # Returns Document
        def [](slug)
          data[slug.to_s]
        end

        # Public
        #
        # Получение документа по его URL
        #
        # Arguments
        #   path - String -  строка разделенная '/' (пример "/module/document/some_function")
        #
        # Example usage:
        #   Apress::Documentation.fetch_document('module_name/document/test')
        def fetch_document(path)
          keys = path.split('/')
          doc = data[keys.shift]
          return unless doc

          keys.each do |key|
            doc = doc.documents[key] || (doc.respond_to?(:swagger_documents) && doc.swagger_documents[key])
            break unless doc
          end

          doc
        end

        # Public
        #
        # Удаление всех документов, используется для тестирования
        #
        # Example usage:
        #  Apress::Documentation.reset!
        def reset!
          @data = {}
        end
      end
    end
  end
end
