module Apress
  module Documentation
    class DependencyPresenter
      def initialize(view, document)
        @view = view
        @document = document
      end

      def render_deps(reverse: false)
        @view.render(
          'apress/documentation/presenters/dependency_presenter/dependencies',
          dependencies: dependencies(reverse: reverse),
          all_dependencies: all_dependencies(reverse: reverse),
          current_document: @document
        )
      end

      private

      # Private: определяет зависимости из других модулей для @document и его потомков
      #
      # Arguments:
      #  reverse - см - Apress::Documentation::Storage::BaseStorage::dependencies
      #
      # Returns Array of Pairs [[doc, depend_doc], [doc_3, depend_doc]
      def dependencies(reverse: false)
        all_dependencies(reverse: reverse).select do |from, to|
          from.current_module != @document.current_module ||
          to.current_module != @document.current_module
        end
      end

      # Private: определяет все зависимости для @document и его потомков
      #
      # Arguments:
      #  reverse - см - Apress::Documentation::Storage::BaseStorage::dependencies
      #
      # Returns Array of Pairs [[doc, depend_doc], [doc_3, depend_doc]
      def all_dependencies(reverse: false)
        @dependencies ||= Hash.new do |h, key|
          h[key] = @document.dependencies(reverse: key)
          h[key] = child_dependencies(@document, reverse: key) if h[key].blank?
          h[key]
        end

        @dependencies[reverse]
      end

      # Private: рекурсивно находит все зависимости среди потомков document
      #
      # Arguments:
      #  document - (Document) - документ для которого ищем зависимости
      #  reverse - см - Apress::Documentation::Storage::BaseStorage::dependencies
      #
      # Returns Array of Pairs [[doc, depend_doc], [doc_3, depend_doc]
      def child_dependencies(document, reverse: false)
        unless document.respond_to?(:documents)
          return document.dependencies(reverse: reverse)
        end

        child_deps = document.documents.inject([]) do |deps, (_, doc)|
          deps.concat(child_dependencies(doc, reverse: reverse))
        end

        document.swagger_documents.inject(child_deps) do |deps, (_, doc)|
          deps.concat(doc.dependencies(reverse: reverse))
        end

        child_deps.concat(document.dependencies(reverse: reverse))

        child_deps
      end
    end
  end
end
