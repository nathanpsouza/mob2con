class Convertions::PrivateController < ApplicationController
  include Convertable
  
  before_action :authenticate_user
  
  def collection
    Convertion.private_convertion
  end

  def convertion_type
    Convertion::convertion_types[:private_convertion]
  end
end
