require 'spec_helper'

RSpec.describe Apress::Documentation::DocumentsHelper, type: :helper do
  include Rails.application.routes.url_helpers

  describe '#document_url_with_swagger' do
    let(:document) { Apress::Documentation::Storage::Document.new('test') }
    let(:swagger_document) { Apress::Documentation::Storage::SwaggerDocument.new(document, 'test') }
    it 'returns url for document' do
      expect(helper.document_url_with_swagger(document)).to match('/documentation/test')
    end

    it 'returns url for swagger document' do
      expect(helper.document_url_with_swagger(swagger_document)).to match('/documentation/test#!/test/')
    end
  end
end
