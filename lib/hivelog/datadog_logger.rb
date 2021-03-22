# frozen_string_literal: true
require 'ddtrace'

module Hivelog
  class DatadogLogger < Logger

    def datadog_body
      correlation = Datadog.tracer.active_correlation

      {
        dd: {
          trace_id: correlation.trace_id.to_s,
          span_id: correlation.span_id.to_s,
          env: correlation.env.to_s,
          service: correlation.service.to_s,
          version: correlation.version.to_s,
        },
        ddsource: ['ruby'],
      }
    end

    def build_payload(level, message, options = {})
      payload = super(level, message, options)

      payload.merge(datadog_body)
    end

  end
end
