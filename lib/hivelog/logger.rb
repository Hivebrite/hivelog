require 'elasticsearch'
module Hivelog
  class Logger
    attr_accessor :client, :labels

    LOG_LEVELS = [:debug, :info, :warn, :error, :fatal, :panic]
    LOG_LEVELS.each do |level|
      define_method level do |*message_arg|
        create_message(level, message_arg[0], message_arg[1])
      end
    end

    def initialize(url, labels = {})
      @labels = labels
      @client = Elasticsearch::Client.new host: url
    end
    
    def create_message(level, message, options = {})
      payload = build_payload(level, message, options)
      @client.index index: generate_index, body: payload
    end

    def build_payload(level, message, options = {})
      payload = {
        labels: @labels,
        timestamp: Time.now.utc,
        level: level,
        message: message
      }.merge(options)
    end

    def generate_index
      t = Time.now.utc
      "hivelog-#{t.year}.#{t.month}.#{t.day}"
    end
  end
end