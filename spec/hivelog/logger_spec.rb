RSpec.describe Hivelog::Logger do
  before(:context) do
    url =  "localhost:9200"
    @labels = {
      environment: "production",
      application: "ror"
    }
    @logger = Hivelog::Logger.new(url, @labels)
  end
  it "has an Elasticsearch client" do
    expect(@logger.client).not_to be nil
  end

  Hivelog::Logger::LOG_LEVELS.each do |level|
    it "has #{level} method" do
      expect(@logger.respond_to? level).not_to be nil
    end
  end

  it "has an Elasticsearch client" do
    expect(@logger.client).not_to be nil
  end

  it "can build an event payload" do
    event_dataset = {
      email: "foobar@hiverite.com",
      type: "sent",
      timestamp: Time.now,
    }
    event = {
      action: "sent",
      id: "12345",
      category: "email",
      dataset: event_dataset,
    }
    user = {
      id: 123,
      name: "John Smith",
      type: "User"      
    }
    group = {
      id: 5,
      name: "EM PARIS"
    }
    tags = ["production", "env2"]
    options = {
      event: event,
      user: user,
      group: group,
      tags: tags
    }
    payload = @logger.build_payload("debug", "toto", options)
    expect(payload[:level]).to eq "debug"
    expect(payload[:message]).to eq "toto"
    expect(payload[:labels]).to eq @labels
  end

  it "can send a debug message" do
    expect(@logger).to receive(:create_message).and_return(true)
    @logger.debug("debbbbb")
  end

end