RSpec.describe Fixer do
  describe 'intialize' do
    context 'with only api_key param' do
      it 'intialize class with api params' do
        fixer = Fixer.new(ENV['FIXER_API_KEY'])

        expect(fixer.api_key).to eq(ENV['FIXER_API_KEY'])
        expect(fixer.base).to eq('EUR')
        expect(fixer.symbols).to eq('BRL,USD')
        expect(fixer.uri).to be_a(URI::HTTP)
      end
    end

    context 'with base and symbols params' do
      it 'intialize class with api params' do
        fixer = Fixer.new(ENV['FIXER_API_KEY'], 'BRL', 'USD')

        expect(fixer.api_key).to eq(ENV['FIXER_API_KEY'])
        expect(fixer.base).to eq('BRL')
        expect(fixer.symbols).to eq('USD')
        expect(fixer.uri).to be_a(URI::HTTP)
      end
    end
  end

  describe 'rates' do
    context 'with valid attributes' do
      it 'return a hash with rates' do
        fixer = Fixer.new(ENV['FIXER_API_KEY'])

        VCR.use_cassette 'fixer', record: :new_episodes do
          rates = fixer.rates
          expect(rates['BRL']).to eq(4.441469)
          expect(rates['USD']).to eq(1.119294)
        end
      end
    end

    context 'with invalid attributes' do
      context 'with invalid key' do
        it 'raise error' do
          fixer = Fixer.new('INVALID_KEY')

          VCR.use_cassette 'fixer', record: :new_episodes do  
            rates = fixer.rates
            expect(rates['code']).to eq(101)
            expect(rates['type']).to eq('invalid_access_key')
          end
        end
      end
 
      context 'with invalid base' do
        it 'raise error' do
          fixer = Fixer.new(ENV['FIXER_API_KEY'], 'INV')

          VCR.use_cassette 'fixer', record: :new_episodes do
            rates = fixer.rates
            expect(rates['code']).to eq(201)
            expect(rates['type']).to eq('invalid_base_currency')
          end
        end
      end

      context 'with invalid symbols' do
        it 'raise error' do
          fixer = Fixer.new(ENV['FIXER_API_KEY'], 'EUR', 'INV')

          VCR.use_cassette 'fixer', record: :new_episodes do  
            rates = fixer.rates
            expect(rates['code']).to eq(202)
            expect(rates['type']).to eq('invalid_currency_codes')
          end
        end
      end
    end
  end
end