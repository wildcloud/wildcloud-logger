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
    class Logger

      LEVELS = {:debug => 10, :info => 20, :warn => 30, :error => 40, :fatal => 50}

      attr_accessor :level, :application

      def initialize(application = 'default', level = :debug)
        @level = level
        @stack = []
        @base = proc { |msg|}
        @application = application
        @app = nil
      end

      def base=(base)
        @base = base
        @app = nil
      end

      def add(middleware, options = nil)
        @stack << [middleware, options]
        @app = nil
      end

      def remove(middleware)
        @stack.delete_if do |mw|
          middleware == mw[0]
        end
        @app = nil
      end

      def build
        @app = @stack.reverse.inject(@base) do |app, middleware|
          clazz, options = middleware
          if options
            clazz.new(app, options)
          else
            clazz.new(app)
          end
        end
      end

      def add_level(name, score)
        LEVELS[name] = score
      end

      def remove_level(name)
        LEVELS.delete(name)
      end

      def log(level, component=nil, message = nil, options = nil)
        return if LEVELS[level] < LEVELS[self.level]
        message = yield if block_given?
        component, message = nil, component unless message
        options ||= {}
        msg = options.merge!({
                                 :level => level,
                                 :application => @application,
                                 :component => component,
                                 :message => message,
                                 :timestamp => Time.now.to_i
                             })
        call(msg)
      end

      def call(msg)
        build unless @app
        @app.call(msg)
      end

      def method_missing(name, *args, &block)
        return super(name, *args, &block) unless LEVELS.has_key?(name)
        log(name, args[0], args[1], args[2], &block)
      end

    end
  end
end