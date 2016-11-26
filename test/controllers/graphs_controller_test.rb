require 'test_helper'

class GraphsControllerTest < ActionDispatch::IntegrationTest
  test 'should only repond to JS' do
    Service::CurrencyLayer.stubs(:fetch_week).returns({})
    assert_raise ActionController::UnknownFormat do 
      get "/fetch"
    end
  end

  test 'render highstocks chart if data was retrieved correctly' do
    Service::CurrencyLayer.stubs(:fetch_week).returns({
      10 => { :ARS=>0.21, :EUR=>3.59, :USD=>3.39 },
      14 => { :ARS=>0.22, :EUR=>3.60, :USD=>3.41 }
    })

    get "/fetch", xhr: true
    assert_match /Highcharts\.stockChart/, @response.body
  end

  test 'should not display chart if no data was fetched' do
    Service::CurrencyLayer.stubs(:fetch_week).returns({})
    get "/fetch", xhr: true
    assert_no_match /Highcharts\.stockChart/, @response.body
  end
end
