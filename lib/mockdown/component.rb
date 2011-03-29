module Mockdown
  # This class represents a visual object.
  class Component
    ############################################################################
    # Constructor
    ############################################################################
    
    def initialize()
      @properties = {}
      @property_values = {}
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
    # Properties
    ####################################
    
    # Adds a property to the component.
    #
    # @param [Property] property  the property to add.
    def add_property(property)
      @properties[property.name] = property
    end

    # Retrieves a property definition on the component.
    #
    # @param [String] name  the property name.
    #
    # @return [Property]  the property definition.
    def get_property(name)
      return @properties[name]
    end
    
    # Proxies calls to the object's properties
    def method_missing(sym, *args, &block)
      # Determine the property name and if it is a setter
      property_name = sym.to_s
      accessor = (property_name[-1..-1] != "=")
      property_name.chop! unless accessor
      property = @properties[property_name]
      
      # If the property exists, use it.
      if property
        if accessor
          return @property_values[property_name]
        else
          value = *args
          @property_values[property_name] = property.parse(value)
        end
        
      # Otherwise throw an error
      else
        raise StandardError.new("Property does not exist on component: #{property_name}")
      end
    end
    
    
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

require 'mockdown/component/property'
require 'mockdown/component/container'
require 'mockdown/component/row'
require 'mockdown/component/column'
require 'mockdown/component/descriptor'

