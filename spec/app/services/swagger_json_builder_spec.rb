require 'spec_helper'

RSpec.describe Apress::Documentation::SwaggerJsonBuilder, type: :service do
  describe '#call' do
    let(:service) { described_class.new(slug) }
    before do
      klass = Class.new(Apress::Documentation::Swagger::Schema) do
        swagger_path 'api/test' do
          operation :get
        end
      end
      klass.document_slug = slug

      Class.new(Apress::Documentation::Swagger::Schema) do
        swagger_path 'api/test2' do
          operation :get
        end
      end
    end

    context 'when slug is present' do
      let(:slug) { 'test' }

      it 'filters paths' do
        data = service.call[:paths]
        expect(data).to include :"api/test"
        expect(data).not_to include :"api/test2"
      end
    end

    context 'without slug' do
      let(:slug) { nil }

      it 'returns all data' do
        data = service.call[:paths]
        expect(data).to include :"api/test"
        expect(data).to include :"api/test2"
      end
    end
  end
end
