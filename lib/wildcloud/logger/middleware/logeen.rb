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

require 'socket'
require 'thread'

module Wildcloud
  module Logger
    module Middleware
      class Logeen

        class Connection < EventMachine::Connection

          def initialize(logger)
            super
            @logger = logger
          end

          def unbind
            @logger.reconnect
            @logger = nil
          end
        end

        def reconnect
          @socket = EventMachine.connect(@options[:address], @options[:port], Connection, self)
        end

        def initialize(app, options = {})
          @options = options
          @queue = Queue.new
          @app = app
          reconnect
          @thread = Thread.new do
            loop do
              msg = @queue.pop.to_s
              msg = "#{msg.size}\n0#{msg}"
              @socket.send_data(msg)
            end
          end
        end

        def call(msg)
          @queue << msg[:json_encoded]
          @app.call(msg)
        end

      end
    end
  end
end