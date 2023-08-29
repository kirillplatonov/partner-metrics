module MetricsHelper

  def chart_tile_display_value(chart_tile_display, value)
    case chart_tile_display
    when "number"
      number_with_delimiter(value, delimiter: ',')
    when "percentage"
      number_to_percentage(value, precision: 2)
    else
      number_to_currency_with_precision(value)
    end
  end

  def number_to_currency_with_precision(value)
    precision = value < 100 ? 2 : 0
    number_to_currency(value, precision: precision)
  end

  def number_to_percentage_with_precision(value)
    precision = (value < 10) ? 2 : 1
    percentage = number_to_percentage(value, precision: precision)
    (value > 0) ? "+" + percentage : percentage
  end

  def metric_change_color(metric_change, direction_good)
    case direction_good
    when "up"
      return :success if metric_change > 0.01
      return :critical if metric_change < -0.01
    else
      return :success if metric_change < -0.01
      return :critical if metric_change > 0.01
    end
    :subdued
  end

  def show_averages(period, type)
    types = ["average", "lifetime_value", "repeat_customers"]
    !types.include?(type["type"]) || type["calculation"] != "average"
  end

  def periods_ago(period)
    [1, 2, 3, 6, 12]
  end

  def period_ago_in_words(date, period, period_ago)
    past_date = date - (period * period_ago).days
    raw_text = distance_of_time_in_words(date, past_date)
    clean_text = raw_text.gsub('about', '').gsub('almost', '')
    "#{clean_text} ago"
  end

  def period_word(period)
    case period
    when 30 then "Month"
    when 7 then "Week"
    else "Day"
    end
  end

  def metrics_chart_options
    {
      download: true,
      library: {
        pointSize: 2,
        animation: {
          startup: true,
          duration: 1200,
          easing: 'inAndOut'
        },
        lineWidth: 4,
        colors: ["#5912D5"],
        explorer: {
          keepInBounds: true,
          axis: 'horizontal',
          maxZoomIn: 0.5,
          maxZoomOut: 1,
          zoomDelta: 1.1
        },
        vAxis: {
          format: 'short',
          gridlines: {
            color: "#F1F2F4"
          }
        },
        chartArea: {
          width: '100%',
          height: '80%',
          left: '5%'
        }
      }
    }
  end
end
