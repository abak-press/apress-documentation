require 'spec_helper'

def form_params(p)
  if Rails::VERSION::MAJOR > 4
    {params: p}
  else
    p
  end
end

describe Apress::Documentation::DocumentsController, type: :controller do
  after do
    Apress::Documentation.data.clear
  end

  describe '#show' do
    before do
      Apress::Documentation.build(:docs) do
        document(:doc1, title: 'test')
      end
    end

    context 'without params' do
      it 'response with 200' do
        get :show

        expect(assigns(:document)).to be_nil
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with path' do
      it 'response with 200' do
        get :show, form_params(path: 'docs/doc1')

        expect(assigns(:document).title).to eq 'test'

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
