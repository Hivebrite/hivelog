# frozen_string_literal: true
RSpec.describe(Hivelog::Logger) do
  before(:context) do
    @labels = {
      environment: 'production',
      application: 'ror',
    }
  end

  context 'Elasticsearch output' do
    it 'has an Elasticsearch client' do
      url = 'localhost:9200'
      logger = Hivelog::Logger.new(:elasticsearch, :warn, @labels, url)
      expect(logger.client).to(be_a(Elasticsearch::Transport::Client))
    end
  end

  Hivelog::Logger::LOG_LEVELS.each do |level|
    it "has #{level} method" do
      expect(@logger.respond_to?(level)).not_to(be(nil))
    end
  end

  describe 'build_payload' do
    let(:logger) { Hivelog::DatadogLogger.new(:stdout, :warn, @labels) }

    let(:custom_fields) do
      {
        email: 'foobar@hiverite.com',
        type: 'sent',
        timestamp: Time.now,
      }
    end

    let(:event) do
      {
        action: 'sent',
        id: '12345',
        category: 'email',
        custom_fields: custom_fields,
      }
    end

    let(:user) do
      {
        id: '123',
        name: 'John Smith',
        type: 'User',
      }
    end

    let(:organization) do
      {
        id: '123',
        name: 'Notre Dame',
      }
    end

    let(:group) do
      {
        id: '5',
        name: 'Chicago group',
      }
    end

    let(:tags) { %w[production env2] }

    let(:options) do
      {
        event: event,
        user: user,
        group: group,
        tags: tags,
      }
    end

    let(:message) { 'debbbbb' }

    it 'can build an event payload' do
      payload = logger.build_payload('debug', 'toto', options)

      expect(payload[:level]).to(eq('debug'))
      expect(payload[:message]).to(eq('toto'))
      expect(payload[:labels]).to(eq(@labels))
    end

    it 'can send a debug message' do
      allow(logger).to(receive(:create_message).and_return(true))

      logger.debug(message, {})

      expect(logger).to(have_received(:create_message))
    end

    it 'do not send a lower level message' do
      allow(logger).to(receive(:build_payload))

      logger.info(message, {})

      expect(logger).not_to(have_received(:build_payload))
    end
  end
end
