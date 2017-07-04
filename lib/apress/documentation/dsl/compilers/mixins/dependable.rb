module Apress
  module Documentation
    module Dsl
      module Mixins
        module Dependable
          # Public: создает зависимости между документами, является частью DSL
          #
          # Arguments:
          #   documents_slugs - Массив полных слагов для документом от которых зависит текущий документ.
          # Examples:
          #   Apress::Documentation.build(:module) do
          #     document(:doc2) do
          #       depends_on('module/doc1', 'other_model/other_document')
          #     end
          #
          #     document(:doc1)
          #   end
          #
          def depends_on(*documents_slugs)
            documents_slugs.each do |document_slug|
              document = Apress::Documentation::Storage::Modules.instance.fetch_document(document_slug)
              document ||= document_slug
              Apress::Documentation::Storage::DependencyGraph.instance.add_document(document)
              Apress::Documentation::Storage::DependencyGraph.instance.add_dependency(@target, document)
            end
          end
        end
      end
    end
  end
end
