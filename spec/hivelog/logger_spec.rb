RSpec.describe Hivelog::Logger do
  before(:context) do
    @labels = {
      environment: "production",
      application: "ror"
    }
  end

  context "Elasticsearch output" do
    before(:each) do
      host = "localhost"
      @es_options = {
        host: host,
        user: "hivebrite",
        password: "12345"
      }
    end
    it "has an Elasticsearch client" do
      logger = Hivelog::Logger.new(:elasticsearch, :warn, @labels, @es_options)
      expect(logger.client).not_to be nil
    end

    it "can send a elasticsearch bulk message" do
      logger = Hivelog::Logger.new(:elasticsearch, :debug, @labels, @es_options)
      options = {}
      a_ops = [options]
      expect(logger).to receive(:es_bulk_insert)
      logger.debug("debbbbb", a_ops)
    end
  end

  Hivelog::Logger::LOG_LEVELS.each do |level|
    it "has #{level} method" do
      expect(@logger.respond_to? level).not_to be nil
    end
  end

  it "can build an event payload" do
    logger = Hivelog::Logger.new(:stdout, :warn, @labels)
    custom_fields = {
      email: "foobar@hiverite.com",
      type: "sent",
      timestamp: Time.now,
    }
    event = {
      action: "sent",
      id: "12345",
      category: "email",
      custom_fields: custom_fields,
    }
    user = {
      id: "123",
      name: "John Smith",
      type: "User"      
    }
    organization = {
      id: "123",
      name: "Notre Dame"
    }
    group = {
      id: "5",
      name: "Chicago group"
    }
    tags = ["production", "env2"]
    options = {
      event: event,
      user: user,
      group: group,
      tags: tags
    }
    payload = logger.build_payload("debug", "toto", options)
    expect(payload[:level]).to eq "debug"
    expect(payload[:message]).to eq "toto"
    expect(payload[:labels][:payload]).to eq "hivelog"
    expect(payload[:labels][:environment]).to eq "production"
    expect(payload[:labels][:application]).to eq "ror"
  end

  it "can send a debug message" do
    logger = Hivelog::Logger.new(:stdout, :debug, @labels)
    options = {}
    expect(logger).to receive(:create_message).and_return(true)
    logger.debug("debbbbb", options)
  end

  it "do not send a lower level message" do
    logger = Hivelog::Logger.new(:stdout, :warn, @labels)
    options = {}
    expect(logger).not_to receive(:build_payload)
    logger.info("debbbbb", options)
  end
end