module APIHelper
  EVENTS_FILE = File.join("spec", "fixtures", "events.json")

  def self.create_json_fixture
    philly_events = LocalEvents.new("Philadelphia", "PA")
    body = philly_events.response.body

    File.open(APIHelper::EVENTS_FILE, "w") do |file|
      data = JSON.parse(body)
      file.puts(JSON.pretty_generate(data))
    end
  end
end
