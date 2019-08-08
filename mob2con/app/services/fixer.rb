class Fixer
  attr_accessor :api_key, :base, :symbols, :uri

  def initialize(api_key, base = 'EUR', symbols = 'BRL,USD')
    @uri = URI('http://data.fixer.io/api/latest')
    @api_key = api_key
    @base = base
    @symbols = symbols
  end

  def rates
    set_query_string
    res = Net::HTTP.get_response(@uri)
    json = JSON.parse(res.body)
    json['success'] ? json['rates'] : json['error']
  end

  private 

  def set_query_string
    params = { access_key: @api_key, base: @base, symbols: @symbols }
    @uri.query = URI.encode_www_form(params)
  end
end