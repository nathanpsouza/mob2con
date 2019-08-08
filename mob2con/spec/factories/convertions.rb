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

FactoryBot.define do
  factory :convertion do
    currency_from { ['BRL', 'USD', 'EUR'].sample }
    currency_to { ['BRL', 'USD', 'EUR'].sample }
    rate { rand(1.0..4.0) }
    convertion_type { Convertion::convertion_types[:public_convertion] }

    factory :private_convertion do
      convertion_type { Convertion::convertion_types[:private_convertion] }
    end
  end
end
