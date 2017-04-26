RSpec.describe LocalEvents do
  # read JSON from file instead of making an API request
  let(:events_content) { File.read(APIHelper::EVENTS_FILE) }
  let(:json) { JSON.parse(events_content) }
  before { allow_any_instance_of(LocalEvents).to receive(:json).and_return(json) }

  describe "#to_s" do
    it "returns a listing of events" do
      events = LocalEvents.new("Philadelphia", "PA")
      expect(events.to_s).to include("Hedgehog Drama")
      expect(events.to_s).to include("Kid Handsome")
    end
  end
end
