# Copyright 2011 Marek Jelen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Wildcloud
  module Logger
    module Middleware
      class Amqp

        def initialize(app, options = {})
          @app = app
          @exchange = options[:exchange]
          @key = options[:key] ? options[:key] : :json_encoded
          @options = options
          @options[:call_routing_key] = true if @options[:routing_key].respond_to?(:call)
        end

        def call(msg)
          options = {}
          case
            when @options[:call_routing_key]
              key = @options[:routing_key].call(msg)
              options[:routing_key] = key if key
            when @options[:routing_key]
              options[:routing_key] = @options[:routing_key]
            else
              options[:routing_key] = ''
          end
          @exchange.publish(msg[@key], options)
          @app.call(msg)
        end

      end
    end
  end
end