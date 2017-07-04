require 'spec_helper'

RSpec.describe Apress::Documentation::DependencyPresenter, type: :presenter do
  let(:view) { ActionView::Base.new }
  before do
    Apress::Documentation.build(:module) do
      document(:document) do
        depends_on('module/other_document')
      end

      document(:other_document)
    end

    Apress::Documentation.build(:other_module) do
      document(:document) do
        depends_on('module/document')
      end
    end
  end

  let(:document) { Apress::Documentation.fetch_document('module/document') }
  let(:other_document) { Apress::Documentation.fetch_document('module/other_document') }
  let(:other_module_document) { Apress::Documentation.fetch_document('other_module/document') }
  let(:presenter) { described_class.new(view, current_document) }

  describe '#render_deps' do
    context 'when dependencies' do
      let(:current_document) { document }
      it 'calls proper render' do
        expect(view).to receive(:render).with(
          "apress/documentation/presenters/dependency_presenter/dependencies",
          dependencies: [],
          all_dependencies: [[document, other_document]],
          current_document: current_document
        )

        presenter.render_deps
      end
    end

    context 'when consumers' do
      let(:current_document) { document }
      it 'calls proper render' do
        expect(view).to receive(:render).with(
          "apress/documentation/presenters/dependency_presenter/dependencies",
          all_dependencies: [[document, other_module_document]],
          dependencies: [[document, other_module_document]],
          current_document: current_document
        )

        presenter.render_deps(reverse: true)
      end
    end

    context 'for module document' do
      before do
        Apress::Documentation.build(:module) do
          document(:doc) do
            depends_on('module/doc2')
          end

          document(:doc2)

          document(:doc) do
            document(:doc3) do
              depends_on('module/doc4')
            end
          end

          document(:doc4) do
            depends_on 'module_2/form'
          end
        end

        Apress::Documentation.build(:module_2) do
          document(:form)
        end
      end

      let(:current_document) { Apress::Documentation.fetch_document('module') }
      it 'calls proper render' do
        doc = Apress::Documentation.fetch_document('module/doc')
        doc2 = Apress::Documentation.fetch_document('module/doc2')
        doc3 = Apress::Documentation.fetch_document('module/doc/doc3')
        doc4 = Apress::Documentation.fetch_document('module/doc4')
        form = Apress::Documentation.fetch_document('module_2/form')
        expect(view).to receive(:render).with(
          "apress/documentation/presenters/dependency_presenter/dependencies",
          all_dependencies: [[document, other_document], [doc3, doc4], [doc, doc2], [doc4, form]],
          dependencies: [[doc4, form]],
          current_document: current_document
        )

        presenter.render_deps
      end
    end
  end
end
