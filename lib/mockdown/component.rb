require 'mockdown/component/property'
require 'mockdown/component/descriptor'

module Mockdown
  # This class represents a visual object.
  class Component
    ############################################################################
    # Static Methods
    ############################################################################
    
    @@class_properties = {}
    
    # Adds a property for a Ruby-based component class. Properties created with
    # Mockdown should be added via add_property().
    #
    # @param [String] name  the name of the property.
    # @param [String] type  the data type of the property.
    def self.add_property(name, type)
      @@class_properties[name] = Property.new(name, type)
    end

    # Retrieves a property declared by a Ruby class.
    #
    # @param [String] name  the name of the property to retrieve.
    #
    # @return [Property]  the property with the given name.
    def self.get_property(name)
      return @@class_properties[name]
    end

    # Retrieves a hash of all properties.
    def self.get_properties()
      return @@class_properties
    end
    
    
    ####################################
    # Properties
    ####################################

    add_property('x', 'integer')
    add_property('y', 'integer')

    add_property('width', 'integer')
    add_property('height', 'integer')

    add_property('min_width', 'integer')
    add_property('min_height', 'integer')

    add_property('max_width', 'integer')
    add_property('max_height', 'integer')
    

    ############################################################################
    # Constructor
    ############################################################################
    
    def initialize(options={})
      @properties = {}
      @property_values = {}
      @children = []
      
      initialize_properties()
      
      # Copy initializaion properties
      options.each_pair do |k, v|
        self.__send__ "#{k.to_s}=", v
      end
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
    # Dimension
    ####################################

    # The width of the component, in pixels.
    attr_accessor :pixel_width

    # The height of the component, in pixels.
    attr_accessor :pixel_height


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

    # Adds a hash of properties to the component.
    #
    # @param [Property] hash  the hash of properties to add.
    def add_properties(hash)
      @properties.merge!(hash)
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


    ####################################
    # Display
    ####################################
    
    # Measures the component and sets the width and height.
    def measure()
      measure_explicit()
      measure_children()
      measure_implicit()
    end
    
    # Lays out child components.
    def layout()
    end
    
    # Renders visual content to the display.
    def render()
    end
    

    ############################################################################
    # Protected Methods
    ############################################################################
    
    protected
    
    ####################################
    # Properties
    ####################################

    def initialize_properties()
      @properties.merge!(@@class_properties)
    end


    ####################################
    # Display
    ####################################

    # Sets the pixel width and pixel height if the width and height are set
    # explicitly on the component.
    def measure_explicit()
      if !width.nil?
        self.pixel_width = limit(width, min_width, max_width)
      end
      
      if !height.nil?
        self.pixel_height = limit(height, min_height, max_height)
      end
    end

    # Recursively invokes measurement on each child.
    def measure_children()
      children.each do |child|
        child.measure()
      end
    end

    # Measures the component as the largest dimensions of its children.
    def measure_implicit()
      # Implicitly measure width
      if width.nil?
        # Set width to largest child
        w = children.map{|child| child.pixel_width}.max || 0
        
        # TODO: Add padding
        # w = w + padding_left + padding_right
			
			  # Restrict min/max
			  self.pixel_width = limit(w, min_width, max_width)
      end

      # Implicitly measure height
      if height.nil?
        # Set height to largest child
        h = children.map{|child| child.pixel_height}.max || 0
        
        # TODO: Add padding
        # h = h + padding_top + padding_bottom
			
			  # Restrict min/max
			  self.pixel_height = limit(h, min_height, max_height)
      end
    end


    ####################################
    # Utility
    ####################################

    # Limits a value within a given range.
    def limit(value, min, max)
      if !min.nil? && value < min
        return min
      elsif !max.nil? && value > max
        return max
      else
        return value
      end
    end
  end 
end

require 'mockdown/component/container'
require 'mockdown/component/row'
require 'mockdown/component/column'

