require 'test_helper'

class CurrencyLayerTest < ActiveSupport::TestCase
  test 'should not return daily quotes if there is a network error' do
    Net::HTTP.stubs(:get).raises(SocketError)
    assert_nil Service::CurrencyLayer.fetch_rate(Date.today)
  end

  test 'should not return daily quotes if the API response was not successful' do
    Net::HTTP.stubs(:get).returns({ success: false }.to_json)
    assert_nil Service::CurrencyLayer.fetch_rate(Date.today)
  end

  test 'should return daily quotes if the API response was successful' do
    quotes = {"USDARS"=>15.5, "USDBRL"=>3.4}
    Net::HTTP.stubs(:get).returns({ success: true, quotes: quotes }.to_json)

    assert_equal quotes, Service::CurrencyLayer.fetch_rate(Date.today)
  end

  test 'should not return week quotes if no daily quotes were returned' do
    Service::CurrencyLayer.stubs(:fetch_rate).returns(nil)
    assert_empty Service::CurrencyLayer.fetch_week
  end

  test 'should return week quotes if daily quotes were successuly fetched' do
    Service::CurrencyLayer.stubs(:fetch_rate).returns({
      "USDBRL"=>3,
      "USDEUR"=>0.9,
      "USDARS"=>15 
    })
    week_quotes = Service::CurrencyLayer.fetch_week
    assert_not_empty week_quotes 
    assert_equal 7, week_quotes.keys.count
  end
end
