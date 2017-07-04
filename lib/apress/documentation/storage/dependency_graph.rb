require 'singleton'

module Apress
  module Documentation
    module Storage
      # Private: Основное хранилище всех зависимостей между документами
      # Инкапсулирует орентированный граф, вершины которого документы (Document или SwaggerDocument)
      class DependencyGraph
        include Singleton

        # Public: добавление документа
        #
        # Arguments:
        #  document - (String or Document) - документ или его слаг(если документ еще не был создан)
        #
        # Note:
        #   Данный метод позволяет ""лениво"" создавать документы в графе,
        #   подменяя слаг документа, вставленного в граф до создания самого документа, на сам документ
        # Returns nothing
        def add_document(document)
          if graph.has_vertex?(document)
            graph.replace_vertex(document, document)
          else
            graph.add_vertex(document)
          end
        end

        # Public: добавление связи между документами, создает ребро в графе, если оно не было создано
        #
        # Arguments:
        #  document_from - (Document) - документ от который зависит
        #  document_to - (String or Document) - документ или его слаг(если документ еще не был создан)
        #
        # Returns nothing
        def add_dependency(document_from, document_to)
          graph.add_edge(document_from, document_to) unless graph.has_edge?(document_from, document_to)
        end

        # Public: находит все зависимости для заданного документа
        #
        # Arguments:
        #  contract - (Document) - документ для которого определяем зависимости
        #  reverse - (boolean) - флаг, различает тип определяемых зависимостей
        #    возможные значения
        #      - false (default) - документы, от которых зависит текущий документ (AKA зависимости contract)
        #      - true - документы, которые зависят от текущего (AKA потребители contract)
        #
        # Returns Array of Pairs - [[doc_from, doc_to], [doc_from_other, doc_to_other]]
        def dependencies(contract, reverse:)
          dep = []

          condition =
            if reverse
              lambda { |doc, _, to| doc == to }
            else
              lambda { |doc, from, _| doc == from }
            end

          graph.each_edge do |from, to|
            next unless condition.call(contract, from, to)

            dep << (reverse ? [to, from] : [from, to])
          end

          dep
        end

        # Public: валидирует зависимости
        #
        # Throws RuntimeError если найдена вершина неверного типа
        #
        # Returns nothing
        def validate!
          graph.each_vertex do |v|
            unless v.is_a?(Apress::Documentation::Storage::BaseStorage)
              raise "Несуществующий документ - #{v}, объявлен в - #{dependencies(v, reverse: true).map(&:last)}"
            end
          end
        end

        # Public: очищает все текущие зависисмости
        #
        # Returns nothing
        def reset!
          @graph = RGL::DirectedAdjacencyGraph.new
        end

        private

        def graph
          @graph ||= RGL::DirectedAdjacencyGraph.new
        end
      end
    end
  end
end
