require 'test_helper'

require 'test_helper'

class ConditionalMonitoringServiceTest < ActiveSupport::TestCase
  setup do
    @service = ConditionalMonitoringService.new
    @forecast1 = forecasts(:kaunas_rainy)
    @forecast2 = forecasts(:vilnius_sunny)
  end

  test '#check_forecasts' do
    time_range = @forecast1.forecast_timestamp..@forecast2.forecast_timestamp
    conditions = [:rain]

    Forecast.expects(:within_time_range).with(time_range).returns([@forecast1, @forecast2])
    @service.expects(:find_triggers).with([@forecast1, @forecast2], conditions)
    @service.check_forecasts(time_range, conditions)
  end

  test '#will_rain?' do
    assert_equal true, @service.will_rain?(@forecast1)
    assert_equal false, @service.will_rain?(@forecast2)
  end

  test '#find_triggers' do
    assert_equal [{ :rain => @forecast1.forecast_timestamp }], @service.find_triggers([@forecast1, @forecast2], [:rain])
  end
end
