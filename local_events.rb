#!/usr/bin/env ruby
require "date"
require "json"
require "net/http"
require "openssl"

# check for API credentials
raise "SEATGEEK_CLIENT_ID not set!" unless ENV["SEATGEEK_CLIENT_ID"]
raise "SEATGEEK_CLIENT_SECRET not set!" unless ENV["SEATGEEK_CLIENT_SECRET"]

class LocalEvents
  attr_reader :city, :state, :events

  def initialize(city, state)
    @city = city
    @state = state
    @events = get_events
  end

  def to_s
    result = ""
    events.each do |event|
      result += "#{event["title"]} @ #{event["venue"]["name"]} - #{event["datetime_local"]}\n"
    end
    result
  end

  private
  def get_events
    json["events"]
  end

  def json
    JSON.parse(response.body)
  end

  def response
    # memoize the response
    @_response ||= Net::HTTP.get_response(uri)
  end

  def uri
    # http://stackoverflow.com/a/9995704/2675670
    result = URI("https://api.seatgeek.com/2/events")
    result.query = URI.encode_www_form(params)
    result
  end

  def params
    {
      "client_id" => ENV["SEATGEEK_CLIENT_ID"],
      "client_secret" => ENV["SEATGEEK_CLIENT_SECRET"],
      "format" => "json",
      "venue.city" => city,
      "venue.state" => state,
      "datetime_local.gte" => today,
      "datetime_local.lt" => tomorrow
    }
  end

  def today
    yyyy_mm_dd(Date.today)
  end

  def tomorrow
    yyyy_mm_dd(Date.today + 1)
  end

  def yyyy_mm_dd(date)
    date.strftime("%Y-%m-%d")
  end
end

# __FILE__ is the current file
# $0 is the script being executed

# if this script is being executed
if __FILE__ == $0
  # print out the events happening in Boston
  puts LocalEvents.new("Boston", "MA")
end
