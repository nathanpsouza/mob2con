RSpec.shared_examples 'a convertion controller' do
  let(:expected_convertion_type) { }

  describe 'GET #index' do
    let!(:convertions) { FactoryBot.create_list(:convertion, 3) }
    let!(:private_convertions) { FactoryBot.create_list(:private_convertion, 3) }

    it 'return http status ok' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'return a list of convertions' do
      get :index
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.first['convertion_type']).to eq(expected_convertion_type)
    end
  end

  describe 'POST #create' do
    context 'with valid currencies' do
      it 'save convertions to database' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          expect {
            post :create, params: { currency: 'BRL,USD' }
          }.to change(Convertion, :count).by(2)
        end
      end

      it 'return http status created' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          post :create, params: { currency: 'BRL,USD' }
        end

        expect(response).to have_http_status(:created)
      end

      it 'return nothing on body' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          post :create, params: { currency: 'BRL,USD' }
        end

        json = JSON.parse(response.body)
        expect(json).to be_empty
      end

      it 'is created with public type' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          post :create, params: { currency: 'BRL,USD' }
        end

        expect(Convertion.last.convertion_type).to eq(expected_convertion_type)
      end
    end

    context 'with at least one valid currency' do
      it 'save convertions to database' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          expect {
            post :create, params: { currency: 'BRL,INV' }
          }.to change(Convertion, :count).by(1)
        end

        expect(Convertion.last.currency_to).to eq('BRL')
      end

      it 'return http status created' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          post :create, params: { currency: 'BRL,INV' }
        end

        expect(response).to have_http_status(:created)
      end

      it 'return nothing on body' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          post :create, params: { currency: 'BRL,INV' }
        end

        json = JSON.parse(response.body)
        expect(json).to be_empty
      end
    end

    context 'with invalid currencies' do
      it 'do not save convertions on database' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          expect {
            post :create, params: { currency: 'INV' }
          }.to_not change(Convertion, :count)
        end
      end

      it 'return http status unprocessable_entity' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          post :create, params: { currency: 'INV' }
        end

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return errors on body' do
        VCR.use_cassette 'fixer', record: :new_episodes do
          post :create, params: { currency: 'INV' }
        end

        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end

    context 'without any currency' do
      before do
        post :create#, params: { currency: '' }
      end

      it 'return http status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return error on json' do
        json = JSON.parse(response.body)
        expect(json['error']).to eq('you must pass at least one currency on currency attribute.')
      end
    end
  end
end