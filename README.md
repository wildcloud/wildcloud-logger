# Wildcloud - Logger

Logging library extracted from Wildcloud project.

## Status

More work needed.

## Example

The library is distributed as a gem

    gem install wildcloud-logger

Or if you use Bundler (and you should!)

    gem 'wildcloud-logger', :require => 'wildcloud/logger'

Now you can create logger instance and give it an application name

    @logger = Wildcloud::Logger::Logger.new
    @logger.application = 'MyCoolApplication'

Your logger is ready to be used, however all messages will be lost.

To process messages you got to add some middleware.

Most common example during the development is to output messages to console (stdout)

    require 'wildcloud/logger/middleware/console'
    @logger.add(Wildcloud::Logger::Middleware::Console)

More complex example is to publish to some AMQP exchange

    require 'wildcloud/logger/middleware/amqp'
    @topic = AMQP::Channel.new(AMQP.connect()).topic('<<some_exchange_name>>')
    @logger.add(Wildcloud::Logger::Middleware::Amqp, :exchange => @topic, :routing_key => '<<some_routing_key>>')

It's very simple to write new middleware.

## Middleware

* Console - output to $stdout
* Json - encodes message into JSON (JSON.dump(message)) and puts it into the messages as :json_encoded key
* Amqp - publishes message to AMQP exchange, by default takes :json_encoded key

## Design

Logger is inspired by Rack architecture. Wildcloud::Logger::Logger serves as entry point for accepting logging messages,
which are then passed to middleware for further processing.

Logger allows adding custom logging levels and modifying the default ones. Levels are specified as Ruby symbols with
specific score that is used to compare importance. By default Logger provides these levels:

        { :debug => 10, :info => 20, :warn => 30, :error => 40, :fatal => 50 }

## License

Project is licensed under the terms of the Apache 2 license.