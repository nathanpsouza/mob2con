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

class Convertion < ApplicationRecord
  validates :currency_from, presence: true
  validates :currency_to, presence: true
  validates :rate, presence: true, numericality: true

  enum convertion_type: { 
    public_convertion: 'public_convertion', 
    private_convertion: 'private_convertion' 
  }

end
