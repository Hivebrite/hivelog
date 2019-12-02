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
    logger = Hivelog::Logger.new(:stdout, @labels)
    options = {
      event: event,
      user: user,
      group: group,
      tags: tags
    }
    logger.debug("deb ya", options)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
