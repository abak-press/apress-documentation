# Apress::Documentation


## Установка

```ruby
gem 'apress-documentation'
```

## Использвание

Описание любого компонена задается с помощью вызова метода build на главном модуле `Apress::Documentation` и передаче ему блока. Например,
```
Apress::Documentation.build(:module_name, title: 'название модуля') do
  document(:component, title: 'Название компонента') do
    description 'test'
  end
end
```

в самом блоке могут быть вызваны методы document, name, description, business_desc, consumers, publicity, tests, swagger_bind.

#### Описания методов
`document`  определеяет весь документ, является частью построения меню (на каждый документ создается ссылка), данный метод можно вызвать друг друге, например:
```ruby
Apress::Documentation.build(:module_name, title: 'название модуля') do
  document(:component, title: 'Название компонента') do
    description 'test'

    document(:nested_component, title: 'Вложенный документ') do
      description 'test here'
      publicity 'Закрытый'
    end
  end
end
```

также `document` можно вызывать без блока, если нет неообходимости:
```ruby
Apress::Documentation.build(:module_name, title: 'название модуля') do
  document(:component, title: 'Простой компонент соящий упоминания')
end
```

`title` - имя компонента.

`description` - описание компонента.

`business_desc` - бизнес-описание компонента, заполняется менеджером.

`consumers` - перечесление модулей-потребителей.

`tests` - есть ли тесты на компонент, когда были написаны, в рамках какой задачи.

`publicity` - публичность компонента, возможность использования его в других местах, рекомендованные значения -
"Защищеный", "Публичный".

`swagger_bind` реализует возможность дополнить swagger-ui.
разрешенные методы - business_desc, consumers, tests и publicity.
Пример использования:
```ruby
Apress::Documentation.build(:module_name, title: 'название модуля') do
  document(:http_api, title: 'HTTP API') do
    # аргумент id HTML блока в который будет ставлена доп. инфа
    swagger_bind('module_operationID_content') do
      description 'Это апи нужно для того-то'

      consumers 'Other module'

      # тут обычное swagger описание
      swagger_path('some/path/here') do
        operation :get do
          # важно чтобы operation_id и tags совпадали в аргументе swagger_bind
          key :operationId, 'operationID'
          key :tags, ['module']

          ...
        end
      end
    end

    # также аргумент HTML id можно опускать, если operationId и tags заданы
    swagger_bind do
      description 'Это апи нужно для того-то'

      consumers 'Other module'

      # тут обычное swagger описание
      swagger_path('some/path/here') do
        operation :get do
          # Автоматически поддянет значения и создат HTML id - module_operationID_content
          key :operationId, 'operationID'
          key :tags, ['module']

          ...
        end
      end
    end
  end
end
```
