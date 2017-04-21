module Apress
  module Documentation
    module Dsl
      # Private: AbstractClass Базовы класс компилятора DSL
      #
      # задает DSL для настройки DSL (Xzibit style)
      class BaseCompiler
        # Public: Объект в который будут заполняться поля чере DSL
        attr_reader :target

        def initialize(target)
          @target = target
        end

        # Public: Основной метод, задает какие поля объект DSL-класса будет записивать в target
        def self.setters(*method_names)
          method_names.each do |name|
            send :define_method, name do |value|
              @target.send("#{name}=", value)
            end
          end
        end

        # Public: Осуществляет исполнение DSL и заполняет нужные поля в target
        def compile(fields, &block)
          @target.assign(fields)
          instance_eval(&block) if block_given?
        end
      end
    end
  end
end
