# == Schema Information
#
# Table name: convertions
#
#  id              :bigint           not null, primary key
#  convertion_type :string
#  currency_from   :string
#  currency_to     :string
#  rate            :decimal(8, 3)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Convertion, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:currency_from) }
    it { is_expected.to validate_presence_of(:currency_to) }
    it { is_expected.to validate_presence_of(:rate) }
    it { is_expected.to validate_numericality_of(:rate) }
  end
end
