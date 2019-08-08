require 'rails_helper'

RSpec.describe UserTokenController, type: :controller do
  describe 'POST #user_token' do
    let!(:user) { FactoryBot.create(:user) }

    context 'with valid credentials' do
      before do
        post :create, params:  { auth: { email: user.email, password: '123123' } }
      end

      it 'return jwt token' do
        json_response = JSON.parse(response.body)
        expect(json_response['jwt']).to_not be_empty
      end

      it 'return http status ok' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid credentials' do
      before do
        post :create, params:  { auth: { email: user.email, password: '12312' } }
      end

      it 'do not return jwt token' do
        expect(response.body).to be_empty
      end

      it 'return http status ok' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
