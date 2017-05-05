require 'rails/all'
require 'haml-rails'
require 'swagger/blocks'
require 'apress/documentation/swagger/schema'
require 'apress/documentation/storage/swagger_document'
require 'apress/documentation/storage/document'
require 'apress/documentation/storage/modules'
require 'apress/documentation/engine'
require "apress/documentation/version"

# Public: Основной модуль для использования
#
# Содержит методы построения и получения динамически определяемых документов
module Apress
  module Documentation
    def self.modules
      Apress::Documentation::Storage::Modules.instance
    end

    def self.add_load_path(path)
      ActiveSupport.on_load(:documentation) do
        Dir[File.join(path, '/**/*.rb')].each { |file| require file }

        yield if block_given?
      end
    end

    class << self
      extend Forwardable
      def_delegators :modules, :data, :fetch_document, :build
    end
  end
end
