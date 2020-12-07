# Hivelog

Hivebrite ECS events logger. It supports stdout and elasticsearch output.

[ECS Reference](https://www.elastic.co/guide/en/ecs/current/ecs-reference.html)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hivelog'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hivelog

## Usage

```ruby
    labels = {
      environment: "production",
      application: "ror"
    }

    options = {
      event: event,
      user: user,
      group: group,
      tags: tags
    }

    Hivelogger = Hivelog::Logger.new(:stdout, @labels)

    Hivelogger.debug("deb ya", options)
    Hivelogger.warn("warning message", options)
    Hivelogger.info("information message", options)
    Hivelogger.error("error message", options)
```

Each log is a sentence. A sentence always starts with capitalization and ends with a period.

Please scope the service with `tags` (e.g.: `Donations`, `NetworkEvents`, `Recurly`, ...). It will help for filtering.

All logs are not necessary an error. Please, type your logs.
You can use : `info`, `warn`, `error` and `debug`. 

FYI: Hivelogger writes logs on stdout on local by default.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
