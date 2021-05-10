# frozen_string_literal: true
require 'elasticsearch'
require 'time'
require 'json'

module Hivelog
  class Logger

    attr_accessor :client, :labels, :output, :min_level

    LOG_LEVELS = [:debug, :info, :warn, :error, :fatal, :panic].freeze
    OUTPUT = [:stdout, :elasticsearch].freeze
    LOG_LEVELS.each do |level|
      define_method level do |*message_arg|
        create_message(level, message_arg[0], message_arg[1])
      end
    end

    def initialize(op, min_level, labels = {}, url = nil)
      @min_level = min_level
      @output = op
      @client = Elasticsearch::Client.new(host: url) if OUTPUT.include?(output) && output == :elasticsearch
      @labels = labels
    end

    def create_message(level, message, options = {})
      return if LOG_LEVELS.index(@min_level) > LOG_LEVELS.index(level)

      payload = build_payload(level, message, options.to_h)

      if @output == :elasticsearch
        @client.index(index: generate_index(payload[:"@timestamp"]), body: payload)
      elsif @output == :stdout
        STDOUT.print(payload.to_json + "\n")
      end
    end

    def build_payload(level, message, options = {})
      {
        labels: @labels,
        level: level,
        message: message,
        "@timestamp": Time.now.utc,
        ecs: { version: Hivelog::ECS_VERSION },
      }.merge(options)
    end

    def generate_index(event_time)
      t = event_time.utc
      t.strftime("hivelog-%Y.%m.%d")
    end

  end
end
