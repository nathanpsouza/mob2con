require 'rails_helper'

RSpec.describe Convertions::PrivateController, type: :controller do
  it_behaves_like 'a convertion controller' do
    let(:expected_convertion_type) do
      Convertion::convertion_types[:private_convertion]
    end
    let(:user) { FactoryBot.create(:user) }

    before :each do
      token = Knock::AuthToken.new(payload: { sub: user.id }).token
      request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
    end
  end

  describe 'GET #index' do
    context 'without authentication header' do
      it 'return http status unauthorized' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    context 'without authentication header' do
      it 'return http status unauthorized' do
        post :create, params: { currency: 'BRL,USD' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
