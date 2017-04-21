module Apress
  module Documentation
    module Dsl
      module Modules
        # Protected: Точка входа для построения DS
        # используется через делегацию в модуле Apress::Documentation
        #
        #
        # module_slug - Symbol - слаг модуля
        # fields - Hash(optional, default - {}) - поля для установки в короткой записи
        #          (например, Apress::Documentation.build(:slug, title: 'name'))
        # &block - Proc(optional) - вызовы DSL методов
        #
        # Examples
        #
        #   Apress::Documentation.build(:module) do
        #     name 'some module'
        #     description 'tests'
        #   end
        #
        #   Apress::Documentation.build(:module) do
        #     document(:some, title: 'Some doc') do
        #       description 'Тут вставить описание'
        #       publicity 'Публичное'
        #     end
        #   end
        #
        def build(module_slug, fields = {}, &block)
          module_slug = module_slug.to_s
          document = self[module_slug]
          document ||= Apress::Documentation::Storage::Document.new(module_slug)
          document.compile(fields, &block)
          self << document
        end
      end
    end
  end
end
