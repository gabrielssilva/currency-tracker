class Service::CurrencyLayer

  ENDPOINT = "http://apilayer.net/api/historical"
  API_KEY = ENV['CURRENCY_LAYER_API_KEY']
  CURRENCIES = "ARS,BRL,EUR"

  def self.fetch_week
    week_quotes = {}
    week_days = 6.days.ago.to_date .. 0.days.ago.to_date
    week_days.each do |day|
      day_quotes = fetch_rate(day)
      week_quotes[day.to_time.to_i] = index_quotes_in_brl(day_quotes)
    end
    week_quotes
  end

  def self.fetch_rate(date)
    data = Net::HTTP.get(build_uri({
      date: date.strftime("%Y-%m-%d"),
      currencies: CURRENCIES
    }))
    JSON.parse(data)["quotes"]
  end

  private

  def self.build_uri(params)
    uri = URI.parse(ENDPOINT)
    uri.query = URI.encode_www_form(params.merge({
      access_key: API_KEY
    }))
    uri
  end

  def self.index_quotes_in_brl(quotes)
    {
      "ARS": quotes["USDARS"] / quotes["USDBRL"],
      "EUR": quotes["USDEUR"] / quotes["USDBRL"],
      "USD": 1 / quotes["USDBRL"],
    }
  end
end
