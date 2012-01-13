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

require 'thread'

module Wildcloud
  module Logger
    module Middleware
      class File

        def initialize(app, options = {})
          @options = options
          @options[:io].sync = true
          @queue = Queue.new
          @app = app
          @thread = Thread.new do
            loop do
              begin
                msg = @queue.pop
                if @options[:key]
                  log = msg[@options[:key]]
                else
                  log = msg[:level].to_s
                  log << " (#{Time.at(msg[:timestamp])})"
                  log << " :"
                  log << " #{msg[:application]}" if msg[:application]
                  log << " :"
                  log << " #{msg[:component]}" if msg[:component]
                  log << " :"
                  log << " #{msg[:message]}"
                end
                @options[:io].puts(log)
              rescue Exception => e
                puts e.message
              end
            end
          end
        end

        def call(msg)
          @queue << msg
          @app.call(msg)
        end

      end
    end
  end
end