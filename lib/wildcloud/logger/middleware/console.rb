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

      class Console

        COLORS = {:debug => "\e[36m", :info => "\e[32m", :warn => "\e[33m", :error => "\e[31m", :fatal => "\e[35m"}

        def initialize(app, options = {})
          @app = app
          @options = {
              :level_length => 8,
              :component_length => 10
          }.merge(options)
        end

        def call(msg)
          level = msg[:level]
          stdout = "#{COLORS[level]}#{level.to_s.rjust(@options[:level_length])}\e[0m"
          stdout << " (#{Time.at(msg[:timestamp])})"
          stdout << " :"
          stdout << " #{msg[:application]}" if msg[:application]
          stdout << " :"
          stdout << " #{msg[:component].to_s.ljust(@options[:component_length])}" if msg[:component]
          stdout << " :"
          stdout << " #{msg[:message]}"
          stdout << "\n"
          $stdout << stdout
          @app.call(msg)
        end

      end

    end
  end
end