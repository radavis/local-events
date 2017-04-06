#!/usr/bin/env ruby
require "date"
require "json"
require "net/http"
require "openssl"

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
      result += "#{event["title"]} @ #{event["venue"]["name"]}\n"
    end
    result
  end

  private
  def get_events
    JSON.parse(response.body)["events"]
  end

  def http
    # http://augustl.com/blog/2010/ruby_net_http_cheat_sheet/
    result = Net::HTTP.new(uri.host, uri.port)
    result.use_ssl = true
    result.verify_mode = OpenSSL::SSL::VERIFY_NONE
    result
  end

  def request
    result = Net::HTTP::Get.new(uri)
    result
  end

  def response
    @_response ||= http.request(request)
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
      "venue.city" => @city,
      "venue.state" => @state,
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

if __FILE__ == $0
  puts LocalEvents.new("Boston", "MA")
end
