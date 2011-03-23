module Mockdown
  class Parser
    # This class helps the parser construct a component descriptor.
    class Builder
      ##########################################################################
      # Constructor
      ##########################################################################
      
      def initialize()
        @stack = []
      end
      
      
      ##########################################################################
      # Attributes
      ##########################################################################

      # The root descriptor that has been built.
      attr_reader :descriptor
      

      ##########################################################################
      # Methods
      ##########################################################################

      # Adds a descriptor at the specified level.
      #
      # @param [Mockdown::Component::Descriptor] descriptor
      # @param [Integer] level  The level to add the descriptor at.
      def add(descriptor, level)
        # Set the root descriptor
        if level == 0
          # Set descriptor only if it hasn't been set yet.
          if @descriptor.nil?
            @descriptor = descriptor
          else
            raise StandardError.new("Cannot have two root components on a document")
          end
        
        # Add the descriptor on the appropriate parent descriptor
        else
          # Raise error if root descriptor has not been set
          if @descriptor.nil?
            raise StandardError.new("Root component not defined")
          end
          
          # Raise error if level increments more than one
          if level > @stack.length
            raise StandardError.new("Component level specified is too deep")
          end
          
          # Remove items off the stack if we go down levels
          @stack = @stack[0..level-1]
          
          # Add descriptor to parent (last item on stack)
          parent = @stack[-1]
          parent.add_child(descriptor)
        end

        # Add descriptor to stack
        @stack.push(descriptor)
      end
    end
  end 
end