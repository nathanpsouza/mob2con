class Convertions::PublicController < ApplicationController
  include Convertable

  def collection
    Convertion.public_convertion
  end

  def convertion_type
    Convertion::convertion_types[:public_convertion]
  end
end
