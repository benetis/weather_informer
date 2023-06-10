class Meteo
  include HTTParty
  base_uri 'https://api.meteo.lt/v1/places'

  def initialize
    @options = { query: { category: 'forecast' } }
  end

  def get_place(code)
    self.class.get("/#{code}", @options)
  end

  def get_forecast(code)
    self.class.get("/#{code}/forecasts/long-term", @options)
  end

end
