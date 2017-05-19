module Apress
  module Documentation
    module Dsl
      module Mixins
        module Publicity
          ACCESS_MAPPING = {
            public: 'Публичный',
            private: 'Приватный',
            protected: 'Защищеный'
          }.freeze

          # Public: указывает уровень доступа документа, является частью DSL
          #
          # Arguments:
          #   level - Symbol, valid values - :public, :private, :protected
          # Examples:
          #   Apress::Documentation.build(:module) do
          #     document(:doc1) do
          #       publicity :public
          #     end
          #   end
          #
          def publicity(level)
            unless ACCESS_MAPPING.keys.include?(level)
              raise "Неизвестный уровень доступа - #{level}, объявлен в документе #{@target.slug}"
            end

            @target.publicity = ACCESS_MAPPING[level]
          end
        end
      end
    end
  end
end
