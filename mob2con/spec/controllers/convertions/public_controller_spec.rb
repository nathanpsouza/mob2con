require 'rails_helper'

RSpec.describe Convertions::PublicController, type: :controller do
  it_behaves_like 'a convertion controller' do
    let(:expected_convertion_type) do 
      Convertion::convertion_types[:public_convertion]
    end
  end
end
