module Apress
  module Documentation
    module Dsl
      module Utils
        # Private: "Распознает" идентификатор html-tag'а в SwaggerUI по переданному блоку Swagger::Blocks,
        # в который будет вставлена дополнительная информация из SwaggerDocument.
        #
        # Идея: Выполнить блок DSL swagger_path из Swagger::Blocks без вызовов реальных методов.
        #
        # Алгоритм:
        #   - Выполняем переданный блок от swagger_path, пропуская неизвестные методы
        #   - как только нашли первый вызов "key :operationId, value", запоминаем value
        #   - тоже самое для key :tags, [value]
        #   - если после выполнения блока оба значения заданы (@tag, @operation_id) возвращаем результат
        class SwaggerBindPointExtractor
          def extract(&block)
            instance_eval(&block)
            "#{@tag}_#{@operation_id}" if @tag && @operation_id
          end

          def method_missing(name, *args, &block)
            if block_given?
              instance_eval(&block)
            elsif name.to_s == 'key'
              case args[0]
              when :operationId
                @operation_id ||= args[1]
              when :tags
                @tag ||= args[1].try(:first)
              end
            end
          end
        end
      end
    end
  end
end
