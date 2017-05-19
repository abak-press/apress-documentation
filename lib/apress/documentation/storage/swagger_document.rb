require_relative 'base_storage'
require_relative '../dsl/swagger_document'

module Apress
  module Documentation
    module Storage
      # Protected
      #
      # Описывает дополнительные данные для swagger_path в SwaggerUI
      #
      # Алгоритм добавления данных в SwaggerUI:
      #  - записывакем нужные экземпляры этого класса в объекте Document(метод swagger_documents)
      #  - сериализуем данные из swagger_documents во вьюхе в js-переменную (метод as_json в BaseStorage)
      #  - вешаем событие на добавление данных из новосозданной переменной в HTML-таг с id == bind_id
      #  - после отрисовки SwaggerUI, вызываем триггер события, которое добавляет дополнительные данные
      class SwaggerDocument < BaseStorage
        include Apress::Documentation::Dsl::SwaggerDocument
        # Public: Ссылка на документ(Document) в котором записан данный SwaggerDocument
        attr_reader :document
        # Public: tag и openperation_id для SwaggerUI
        attr_reader :tag, :operation_id
        alias_method :title, :operation_id
        # Public: Бизнесс описание - заполняется менаджером
        json_attr :business_desc
        # Public: Наличие тестов, ссылка на задачу с тестами
        json_attr :tests
        # Public: Публичность описываемого функционала - (Закрытый, Защищенный, Публичный)
        json_attr :publicity

        def initialize(document, html_id)
          @document = document
          @tag, @operation_id = html_id.split('_')
          @slug = document.slug + '/' + html_id
        end

        def swagger_class
          return @swagger_class if defined?(@swagger_class)
          @swagger_class = Class.new(Apress::Documentation::Swagger::Schema)
          @swagger_class.document_slug = document.slug
          @swagger_class
        end

        def as_json(options = {})
          json = super(options)

          json[:slug] = slug

          if view = options[:view]
            json[:depends_on] = Apress::Documentation::DependencyPresenter.new(view, self).render_deps
            json[:consumers] = Apress::Documentation::DependencyPresenter.new(view, self).render_deps(reverse: true)
          end

          json
        end

        def current_module
          Apress::Documentation::Storage::Modules.instance[document.slug.to_s.split('/').first]
        end
      end
    end
  end
end
