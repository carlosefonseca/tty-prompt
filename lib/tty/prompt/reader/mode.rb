# encoding: utf-8

require 'io/console'

module TTY
  class Prompt
    class Reader
      class Mode
        # Initialize a Terminal
        #
        # @api public
        def initialize(input = $stdin)
          @input = input
        end

        # Echo given block
        #
        # @param [Boolean] is_on
        #
        # @api public
        def echo(is_on = true, &block)
          if is_on
            yield
          else
            @input.noecho(&block)
          end
        end

        # Use raw mode in the given block
        #
        # @param [Boolean] is_on
        #
        # @api public
        def raw(is_on = true, &block)
          if is_on
            @input.raw(&block)
          else
            yield
          end
        end
      end # Mode
    end # Reader
  end # Prompt
end # TTY
