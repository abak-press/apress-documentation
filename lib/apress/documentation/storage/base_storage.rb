module Apress
  module Documentation
    module Storage
      # Private: AbstractClass, Базовый класс хранилища
      #
      # описывает методы аттрибутов для сериализации в json формата:
      # {
      #   {
      #     "attr_0": send(:attr_0),
      #     "attr_1": send(:attr_1),
      #     ....
      #   }
      # }
      class BaseStorage
        # Public: Составной слаг, используется как URL
        attr_reader :slug

        def self.json_attr_names
          @json_attr_names ||= []
        end

        # Public: Задает аттрибуты для сериализации в json
        def self.json_attr(*method_names)
          json_attr_names.concat(method_names.map(&:to_s))

          attr_accessor(*method_names)
        end

        # Public: Сериализует объект в JSON
        def as_json(options = {})
          self.class.json_attr_names.each_with_object({}) do |attr_name, json|
            value = send(attr_name)

            json[attr_name] = value if value
          end
        end

        # Public: задает аттрибуты на основе хеша
        def assign(options = {})
          options.each do |key, value|
            unless self.class.json_attr_names.include?(key.to_s)
              raise "Undefined attribute #{key}, allowed attributes are #{self.class.json_attr_names}"
            end

            send("#{key}=", value)
          end
        end

        def eql?(other)
          slug == other.to_s
        end
        alias_method :==, :eql?

        def to_s
          slug.to_s
        end

        def hash
          slug.hash
        end

        def inspect
          "<#{self.class} slug = #{slug}>"
        end

        # Public: находит зависимости для текущего документа
        #
        # Arguments:
        #  reverse - флаг для отпеределения какой тип зависимостей нужно вернуть
        #    возможные значения
        #      - false (default) - документы, от которых зависит текущий документ (AKA зависимости self)
        #      - true - документы, которые зависят от текущего (AKA потребители self)
        #
        # Returns Array of Pairs - [[doc1, doc2], [doc1, doc2]]
        def dependencies(reverse: false)
          @dependencies ||= Hash.new do |hash, key|
            hash[key] = Storage::DependencyGraph.instance.dependencies(
              self,
              reverse: key
            )
          end

          @dependencies[reverse]
        end
      end
    end
  end
end
