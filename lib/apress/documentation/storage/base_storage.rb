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
        def self.json_attr_names
          @json_attr_names ||= []
        end

        # Public: Задает аттрибуты для сериализации в json
        def self.json_attr(*method_names)
          json_attr_names.concat(method_names.map(&:to_s))

          attr_accessor(*method_names)
        end

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
      end
    end
  end
end
