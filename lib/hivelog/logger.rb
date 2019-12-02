require 'elasticsearch'
require 'time'
require 'json'

module Hivelog
  class Logger
    attr_accessor :client, :labels, :output

    LOG_LEVELS = [:debug, :info, :warn, :error, :fatal, :panic]
    OUTPUT = [:stdout, :elasticsearch]
    LOG_LEVELS.each do |level|
      define_method level do |*message_arg|
        create_message(level, message_arg[0], message_arg[1])
      end
    end

    def initialize(op, labels = {}, url = nil)
      @output = op
      if OUTPUT.include?(output) && output == :elasticsearch
        @client = Elasticsearch::Client.new host: url
      end
      @labels = labels
    end
    
    def create_message(level, message, options = {})
      payload = build_payload(level, message, options.to_h)
      if @output == :elasticsearch
        @client.index index: generate_index(payload[:"@timestamp"]), body: payload
      elsif @output == :stdout
        STDOUT.print payload.to_json
      end
    end

    def build_payload(level, message, options = {})
      payload = {
        labels: @labels,
        level: level,
        message: message,
        "@timestamp": Time.now.utc,
        ecs: { version: Hivelog::ECS_VERSION }
      }.merge(options)
    end

    def generate_index(event_time)
      t = event_time.utc
      "hivelog-#{t.year}.#{t.month}.#{t.day}"
    end
  end
end