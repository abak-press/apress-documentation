require "spec_helper"

RSpec.describe Apress::Documentation do
  context 'simple build call' do
    before do
      Apress::Documentation.build(:doc) do
        title 'name'
        description 'description'
        publicity :public
        tests 'tests'
      end
    end

    it 'create document' do
      expect(Apress::Documentation.data.size).to eq 1
      doc = Apress::Documentation.data['doc']
      expect(doc.title).to eq 'name'
      expect(doc.description).to eq 'description'
      expect(doc.publicity).to eq 'Публичный'
      expect(doc.tests).to eq 'tests'
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

    it 'create document' do
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

    it 'create all documents' do
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

    it 'create all documents' do
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
      expect(doc.swagger_documents.as_json).to eq(
        "some_point" => {"business_desc" => "cool document 2", slug: "doc/doc1/some_point"}
      )
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
          "some_point" => {
            "business_desc" => "cool document 2",
            "tests" => "somewhere",
            slug: "doc/doc1/some_point"
          }
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
          "tests_testIndex" => {"tests" => "here", slug: "swagger_auto/swagger1/tests_testIndex"}
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

  context 'publicity' do
    context 'when argumens is valid' do
      it 'set proper value to document' do
        Apress::Documentation.build(:module) do
          document(:doc1) do
            publicity :public
          end
        end

        doc = Apress::Documentation.data['module'].documents['doc1']

        expect(doc.publicity).to eq 'Публичный'
      end
    end

    context 'when argument is invalid' do
      it 'raises error' do
        expect do
          Apress::Documentation.build(:module) do
            document(:doc1) do
              publicity :test
            end
          end
        end.to raise_error("Неизвестный уровень доступа - test, объявлен в документе module/doc1")
      end
    end
  end

  context 'dependencies' do
    context 'for document' do
      context 'when refered document exists' do
        before do
          Apress::Documentation.build(:module) do
            document(:doc) do
              depends_on('module/doc2')
            end

            document(:doc2)
          end
        end

        it 'build dependency' do
          doc = Apress::Documentation.data['module'].documents['doc']
          doc2 = Apress::Documentation.data['module'].documents['doc2']
          expect(doc.dependencies).to include [doc, doc2]
        end
      end

      context 'when refered document does exists' do
        before do
          Apress::Documentation.build(:module) do
            document(:doc) do
              depends_on('module/doc2')
            end
          end
        end

        it 'is not valid' do
          doc = Apress::Documentation.data['module'].documents['doc']
          expect { Apress::Documentation.validate_dependencies! }.
            to raise_error("Несуществующий документ - module/doc2, объявлен в - [#{doc.inspect}]")
        end
      end
    end

    context 'for swagger_document' do
      context 'when refered document exists' do
        before do
          Apress::Documentation.build(:module) do
            document(:doc) do
              depends_on('module/doc2')
            end

            document(:doc2)
          end
        end

        it 'build dependency' do
          doc = Apress::Documentation.data['module'].documents['doc']
          doc2 = Apress::Documentation.data['module'].documents['doc2']
          expect(doc.dependencies).to include [doc, doc2]
        end
      end

      context 'when refered document does exists' do
        before do
          Apress::Documentation.build(:module) do
            document(:doc) do
              depends_on('module/doc2')
            end
          end
        end

        it 'is not valid' do
          doc = Apress::Documentation.data['module'].documents['doc']
          expect { Apress::Documentation.validate_dependencies! }.
            to raise_error("Несуществующий документ - module/doc2, объявлен в - [#{doc.inspect}]")
        end
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

  describe '#add_load_path' do
    it 'loads all docs in folder on callback run' do
      Apress::Documentation.add_load_path(Rails.root.join('lib/stub_docs'))

      ActiveSupport.run_load_hooks(:documentation)

      module_document = Apress::Documentation.data['test_load_module']
      expect(module_document.description).to eq 'Cool module'
      expect(module_document.documents['document'].documents['child'].description).to eq 'Cool document'
    end
  end

  context 'config' do
    it 'has default path scope' do
      expect(subject.fetch(:path_scope)).to be_nil
    end

    it 'applies changes' do
      expect { subject[:path_scope] = :cosmos }
        .to change { subject.fetch(:path_scope) }
        .from(nil).to(:cosmos)
    end
  end
end
