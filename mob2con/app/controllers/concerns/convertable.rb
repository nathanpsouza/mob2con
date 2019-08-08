module Convertable
  extend ActiveSupport::Concern

  included do
    before_action :verify_currencies_param, only: [:create]
  end

  def index
    convertions = collection
    render json: convertions, status: :ok
  end

  def create
    if rates.has_key?('code')
      render json: { error: rates }, status: :unprocessable_entity
    else
      save_rates(rates)
      render json: {}, status: :created
    end
  end

  protected

  def verify_currencies_param
    if params[:currency].nil? || params[:currency].blank?
      error = { error: 'you must pass at least one currency on currency attribute.' }
      render json: error, status: :unprocessable_entity
    end
  end
  
  def rates
    currency = params[:currency]
    fixer = Fixer.new(ENV['FIXER_API_KEY'], ENV['DEFAULT_CURRENCY_TO'], currency)
    @rates ||= fixer.rates
  end

  def save_rates(rates)
    rates.each do |key, value|
      Convertion.create(
        currency_from: ENV['DEFAULT_CURRENCY_TO'], 
        currency_to: key, 
        rate: value, 
        convertion_type: convertion_type
      ) 
    end
  end

  def collection
    raise NotImplementedError
  end

  def convertion_type
    raise NotImplementedError
  end
end