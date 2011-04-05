require 'mockdown/component/property'
require 'mockdown/component/property_registry'
require 'mockdown/component/descriptor'

module Mockdown
  # This class represents a visual object.
  class Component
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
    # Component Properties
    ############################################################################

    prop_accessor :x, 'integer', :default => 0
    prop_accessor :y, 'integer', :default => 0

    prop_accessor :width, 'integer'
    prop_accessor :height, 'integer'

    prop_accessor :min_width, 'integer'
    prop_accessor :min_height, 'integer'

    prop_accessor :max_width, 'integer'
    prop_accessor :max_height, 'integer'
    

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
      @property_values[property.name] ||= property.default
    end

    # Adds a hash of properties to the component.
    #
    # @param [Property] hash  the hash of properties to add.
    def add_properties(hash)
      @properties.merge!(hash)
      hash.each_value do |property|
        @property_values[property.name] ||= property.default
      end
    end

    # Retrieves a property definition on the component.
    #
    # @param [String] name  the property name.
    #
    # @return [Property]  the property definition.
    def get_property(name)
      return @properties[name]
    end

    # Retrieves all the properties on the component.
    #
    # @return [Array]  all properties defined on this component.
    def get_properties()
      return @properties
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

    # Adds a properties from class-based components to the component instance.
    def initialize_properties()
      # Find all superclasses
      classes = []
      clazz = self.class
      while !clazz.nil?
        classes << clazz
        clazz = clazz.superclass
      end
      classes.reverse!
      
      # Add properties from each component class
      classes.each do |clazz|
        add_properties(PropertyRegistry.get_properties(clazz))
      end
    end


    ####################################
    # Display
    ####################################

    # Sets the pixel width and pixel height if the width and height are set
    # explicitly on the component.
    def measure_explicit()
      if !width.nil?
        self.pixel_width = Math.limit(width, min_width, max_width)
      end
      
      if !height.nil?
        self.pixel_height = Math.limit(height, min_height, max_height)
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
        
			  # Restrict min/max
			  self.pixel_width = Math.limit(w, min_width, max_width)
      end

      # Implicitly measure height
      if height.nil?
        # Set height to largest child
        h = children.map{|child| child.pixel_height}.max || 0
        
			  # Restrict min/max
			  self.pixel_height = Math.limit(h, min_height, max_height)
      end
    end
  end 
end

require 'mockdown/component/container'
require 'mockdown/component/row'
require 'mockdown/component/column'

