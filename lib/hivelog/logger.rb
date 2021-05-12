require 'elasticsearch'
require 'time'
require 'json'

module Hivelog
  class Logger
    attr_accessor :client, :labels, :output, :min_level

    LOG_LEVELS = [:debug, :info, :warn, :error, :fatal, :panic]
    OUTPUT = [:stdout, :elasticsearch]
    LOG_LEVELS.each do |level|
      define_method level do |*message_arg|
        create_message(level, message_arg[0], message_arg[1])
      end
    end

    def initialize(op, min_level, labels = {}, es_options = {})
      @min_level = min_level
      @output = op
      if OUTPUT.include?(output) && output == :elasticsearch
        @client = Elasticsearch::Client.new hosts: [es_options]
      end
      @labels = labels.merge({"payload": "hivelog"})
    end
    
    def create_message(level, message, options = {})
      return if LOG_LEVELS.index(@min_level) > LOG_LEVELS.index(level)
      if options.is_a?(Array) && @output == :elasticsearch
        es_bulk_insert(level, message, options)
      else
        payload = build_payload(level, message, options)
        if @output == :elasticsearch
          @client.index index: generate_index(payload[:"@timestamp"]), body: payload
        elsif @output == :stdout
          STDOUT.print(payload.to_json + "\n")
        end
      end
    end

    def es_bulk_insert(level, message, a_ops)
      es_body = a_ops.map do |ops|
          payload = build_payload(level, message, ops)
          { index:  { _index: generate_index(payload[:"@timestamp"]), data: payload } }
        end
      @client.bulk(body: es_body)
    end

    def build_payload(level, message, options = {})
      payload = {
        labels: @labels,
        level: level,
        message: message,
        "@timestamp": Time.now.utc,
        ecs: { version: Hivelog::ECS_VERSION }
      }.merge(options.to_h)
    end

    def generate_index(event_time)
      t = event_time.utc
      t.strftime("hivelog-%Y.%m.%d")
    end
  end
end