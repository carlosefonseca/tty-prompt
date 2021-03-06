# encoding: utf-8

require 'forwardable'

module TTY
  class Prompt
    class Reader
      # A class responsible for storing shell interactions history
      #
      # @api private
      class History
        include Enumerable
        extend Forwardable

        # Default maximum size
        DEFAULT_SIZE = 32 << 4

        def_delegators :@history, :size, :length, :to_s, :inspect

        # Set and retrieve the maximum size of the buffer
        attr_accessor :max_size

        attr_reader :index

        attr_accessor :cycle

        attr_accessor :duplicates

        attr_accessor :exclude

        # Create a History buffer
        #
        # param [Integer] max_size
        #   the maximum size for history buffer
        #
        # param [Hash[Symbol]] options
        # @option options [Boolean] :duplicates
        #   whether or not to store duplicates, true by default
        #
        # @api public
        def initialize(max_size = DEFAULT_SIZE, options = {})
          @max_size   = max_size
          @index      = 0
          @history    = []
          @duplicates = options.fetch(:duplicates) { true }
          @exclude    = options.fetch(:exclude) { proc {} }
          @cycle      = options.fetch(:cycle) { false }
          yield self if block_given?
        end

        # Iterates over history lines
        #
        # @api public
        def each
          if block_given?
            @history.each { |line| yield line }
          else
            @history.to_enum
          end
        end

        # Add the last typed line to history buffer
        #
        # @param [String] line
        #
        # @api public
        def push(line)
          @history.delete(line) unless @duplicates
          return if line.to_s.empty? || @exclude[line]

          @history.shift if size >= max_size
          @history << line
          @index = @history.size - 1

          self
        end
        alias << push

        # Move the pointer to the next line in the history
        #
        # @api public
        def next
          return if size.zero?
          if @index == size - 1
            @index = 0 if @cycle
          else
            @index += 1
          end
        end

        def next?
          size > 0 && !(@index == size - 1 && !@cycle)
        end

        # Move the pointer to the previous line in the history
        def previous
          return if size.zero?
          if @index.zero?
            @index = size - 1 if @cycle
          else
            @index -= 1
          end
        end

        def previous?
          size > 0 && !(@index < 0 && !@cycle)
        end

        # Get current line at index
        #
        # @api public
        def pop
          return if size.zero?

          @history[@index]
        end

        # Empty all history lines
        #
        # @api public
        def clear
          @history.clear
          @index = 0
        end
      end # History
    end # Reader
  end # Prompt
end # TTY
