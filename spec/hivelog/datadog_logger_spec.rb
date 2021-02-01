# frozen_string_literal: true
RSpec.describe(Hivelog::DatadogLogger) do
  let(:logger) { described_class.new(:stdout, :warn, @labels) }

  before(:context) do
    @labels = {
      environment: 'production',
      application: 'ror',
    }
  end

  describe 'build_payload' do
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
      allow(logger).to(receive(:datadog_body).and_return({ mocked: true }))

      payload = logger.build_payload('debug', 'toto', options)

      expect(payload[:level]).to(eq('debug'))
      expect(payload[:message]).to(eq('toto'))
      expect(payload[:mocked]).to(eq(true))
      expect(payload[:labels]).to(eq(@labels))
    end
  end

  describe 'datadog_body' do
    it 'has all datadog keys' do
      expect(logger.datadog_body.keys).to(match_array([:dd, :ddsource]))
    end

    it 'has the right ddsource' do
      expect(logger.datadog_body[:ddsource]).to(eq(['ruby']))
    end

    it 'has data in the datadog body' do
      [:trace_id, :span_id, :env, :service, :version].each do |key|
        expect(logger.datadog_body[:dd][key]).not_to(be_nil)
      end
    end
  end
end
