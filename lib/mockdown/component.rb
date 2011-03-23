module Mockdown
  # A component represents a reusable visual object.
  class Component
    ############################################################################
    # Constructor
    ############################################################################
    
    def initialize()
      @children = []
    end


    ############################################################################
    # Attributes
    ############################################################################

    ####################################
    # Hierarchy
    ####################################

    # The parent component that this component is attached to.
    attr_accessor :parent

    # The children attached to this component.
    attr_reader :children


    ####################################
    # Position
    ####################################

    # The absolute position from the left of the parent container.
    attr_accessor :x
    
    # The absolute position from the top of the parent container.
    attr_accessor :y
    

    ############################################################################
    # Methods
    ############################################################################

    ####################################
    # Children
    ####################################
    
    # Add a child to this component.
    def add_child(child)
      child.parent = self
      @children << child
      nil
    end
    
    # Removes a child from this component.
    def remove_child(child)
      child.parent = nil
      @children.delete(child)
      nil
    end
  end 
end

require 'mockdown/component/container'
require 'mockdown/component/row'
require 'mockdown/component/column'
require 'mockdown/component/descriptor'

