class Service::CurrencyLayer

  ENDPOINT = "http://apilayer.net/api/historical"
  CURRENCIES = "ARS,BRL,EUR"

  def self.fetch_week
    week_quotes = {}
    week_days = 6.days.ago.to_date .. 0.days.ago.to_date
    week_days.each do |day|
      day_quotes = fetch_rate(day)
      next if day_quotes.blank?
      timestamp_in_ms = day.to_time.to_i * 1000
      week_quotes[timestamp_in_ms] = index_quotes_in_brl(day_quotes)
    end
    week_quotes
  end

  def self.fetch_rate(date)
    begin
      data = Net::HTTP.get(build_uri({
        date: date.strftime("%Y-%m-%d"),
        currencies: CURRENCIES
      }))

      response = JSON.parse(data)
      response["success"] ? response["quotes"] : nil
    rescue
      nil
    end
  end

  private

  def self.build_uri(params)
    uri = URI.parse(ENDPOINT)
    uri.query = URI.encode_www_form(params.merge({
      access_key: ENV['CURRENCY_LAYER_API_KEY']
    }))
    uri
  end

  def self.index_quotes_in_brl(quotes)
    {
      "ARS": quotes["USDBRL"] / quotes["USDARS"],
      "EUR": quotes["USDBRL"] / quotes["USDEUR"],
      "USD": quotes["USDBRL"],
    }
  end
end
