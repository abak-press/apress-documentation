require "spec_helper"

RSpec.describe Apress::Documentation do
  after do
    Apress::Documentation.data.clear
  end

  context 'simple build call' do
    before do
      Apress::Documentation.build(:doc) do
        title 'name'
        description 'description'
        publicity 'publicity'
        tests 'tests'
        consumers 'consumers'
      end
    end

    it 'creates document' do
      expect(Apress::Documentation.data.size).to eq 1
      doc = Apress::Documentation.data['doc']
      expect(doc.title).to eq 'name'
      expect(doc.description).to eq 'description'
      expect(doc.publicity).to eq 'publicity'
      expect(doc.tests).to eq 'tests'
      expect(doc.consumers).to eq 'consumers'
    end
  end

  context 'without block call' do
    before do
      Apress::Documentation.build(
        :doc,
        title: 'some',
        description: 'test'
      )
    end

    it 'creates document' do
      expect(Apress::Documentation.data.size).to eq 1
      doc = Apress::Documentation.data['doc']
      expect(doc.title).to eq 'some'
      expect(doc.description).to eq 'test'
    end
  end

  context 'when documents is nesting' do
    before do
      Apress::Documentation.build(:doc) do
        document(:doc1) do
          title 'cool document'

          document(:doc2) do
            title 'cool document 2'
          end
        end
      end
    end

    it 'creates all documents' do
      expect(Apress::Documentation.data.size).to eq 1
      doc = Apress::Documentation.data['doc'].documents['doc1']
      expect(doc.title).to eq 'cool document'
      expect(doc.documents['doc2'].title).to eq 'cool document 2'
    end
  end

  context 'when multiple documents in one block call' do
    before do
      Apress::Documentation.build(:doc) do
        document(:doc1) do
          title 'cool document'
        end

        document(:doc2) do
          title 'cool document 2'
        end
      end
    end

    it 'creates all documents' do
      doc = Apress::Documentation.data['doc']
      expect(doc.documents.size).to eq 2
      expect(doc.documents['doc1'].title).to eq 'cool document'
      expect(doc.documents['doc2'].title).to eq 'cool document 2'
    end
  end

  context 'when documents rewretes in next block' do
    before do
      Apress::Documentation.build(:doc) do
        document(:doc1) do
          title 'cool document'
        end

        document(:doc1) do
          title 'cool document 2'
        end
      end
    end

    it 'rewrites it' do
      doc = Apress::Documentation.data['doc']
      expect(doc.documents.size).to eq 1
      expect(doc.documents['doc1'].title).to eq 'cool document 2'
    end
  end

  context 'when document is swagger' do
    before do
      Apress::Documentation.build(:doc) do
        document(:doc1) do
          title 'cool document'

          swagger_bind('some_point') do
            business_desc 'cool document 2'

            swagger_path('api/docs') do
              operation :get
            end
          end
        end
      end
    end

    it 'returns proper json' do
      doc = Apress::Documentation.data['doc'].documents['doc1']
      expect(doc.title).to eq 'cool document'
      expect(doc.swagger_documents.size).to eq 1
      expect(doc.swagger_documents.as_json).to eq("some_point" => {"business_desc" => "cool document 2"})
    end

    context 'when swagger document is rewritten' do
      before do
        Apress::Documentation.build(:doc) do
          document(:doc1) do
            title 'cool document'

            swagger_bind('some_point') do
              tests 'somewhere'

              swagger_path('api/docs') do
                operation :get
              end
            end
          end
        end
      end

      it 'returns proper json' do
        doc = Apress::Documentation.data['doc'].documents['doc1']
        expect(doc.title).to eq 'cool document'
        expect(doc.swagger_documents.size).to eq 1
        expect(doc.swagger_documents.as_json).to eq(
          "some_point" => {"business_desc" => "cool document 2", "tests" => "somewhere"}
        )
      end
    end

    context 'when bind point is not defined' do
      before do
        Apress::Documentation.build(:swagger_auto) do
          document(:swagger1) do
            title 'swagger document'

            swagger_bind do
              tests 'here'

              swagger_path('api/tests') do
                operation :get do
                  key :operationId, 'testIndex'
                  key :tags, ['tests']
                end
              end
            end
          end
        end
      end

      it 'returns proper json' do
        doc = Apress::Documentation.data['swagger_auto'].documents['swagger1']
        expect(doc.title).to eq 'swagger document'
        expect(doc.swagger_documents.size).to eq 1
        expect(doc.swagger_documents.as_json).to eq(
          "tests_testIndex_content" => {"tests" => "here"}
        )
      end
    end

    context 'when paseed field is unknow' do
      it 'raises RuntimeError' do
        expect do
          Apress::Documentation.build(:module, unexpected_field: 'test')
        end.to raise_error RuntimeError
      end
    end
  end

  describe '#fetch_document' do
    before do
      Apress::Documentation.build(:module) do
        document(:doc1) do
          document(:doc2) do
            document(:doc3) do
              title 'test'
            end
          end
        end
      end
    end

    it 'fetches document by path' do
      expect(Apress::Documentation.fetch_document('module/doc1/doc2/doc3').title).to eq 'test'
    end
  end
end
