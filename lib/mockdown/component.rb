require 'mockdown/component/property'
require 'mockdown/component/composite_property'
require 'mockdown/component/property_registry'
require 'mockdown/component/descriptor'

java_import 'java.awt.BasicStroke'
java_import 'java.awt.Color'
java_import 'java.awt.image.BufferedImage'

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
      update_properties(options)
    end


    ############################################################################
    # Component Properties
    ############################################################################

    prop_accessor :x, 'integer', :default => 0
    prop_accessor :y, 'integer', :default => 0

    prop_accessor :width, 'integer'
    prop_accessor :height, 'integer'

    prop_accessor :percent_width, 'integer'
    prop_accessor :percent_height, 'integer'

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
      if @property_values[property.name].nil?
        set_property_value(property.name, property.default)
      end
    end

    # Adds a hash of properties to the component.
    #
    # @param [Property] hash  the hash of properties to add.
    def add_properties(hash)
      @properties.merge!(hash)
      hash.each_value do |property|
        if @property_values[property.name].nil?
          set_property_value(property.name, property.default)
        end
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

    # Updates multiple property values with a hash.
    def update_properties(hash)
      hash.each_pair do |k, v|
        self.set_property_value(k.to_s, v)
      end
    end
    
    # Proxies calls to the object's properties
    def method_missing(sym, *args, &block)
      # Determine the property name and if it is a setter
      property_name = sym.to_s
      accessor = (property_name[-1..-1] != "=")
      raw = (property_name[-1..-1] == "!")
      property_name.chop! if !accessor || raw
      
      if raw
        return get_raw_property_value(property_name)
      elsif accessor
        return get_property_value(property_name)
      else
        value = *args
        return set_property_value(property_name, value)
      end
    end
    
    ####################################
    # Properties Values
    ####################################
    
    # Retrieves the value of a property.
    #
    # @param [String] name  the name of the property.
    #
    # @return               the value set to the property.
    def get_property_value(name)
      property = @properties[name]
      if property
        return property.get_value(self)
      else
        raise StandardError.new("Property does not exist on component: #{name}")
      end
    end
    
    # Sets the value of a property.
    #
    # @param [String] name   the name of the property.
    # @param [Object] value  the value.
    def set_property_value(name, value)
      property = @properties[name]
      if property
        property.set_value(self, value)
      else
        raise StandardError.new("Property does not exist on component: #{name}")
      end
    end

    
    # Retrieves the raw, unformatted property value.
    #
    # @param [String] name  the name of the property.
    #
    # @return               the unformatted value set to the property.
    def get_raw_property_value(name)
      return @property_values[name]
    end
    
    # Sets the raw, unformatted property value.
    #
    # @param [String] name   the name of the property.
    # @param [Object] value  the raw value.
    def set_raw_property_value(name, value)
      @property_values[name] = value
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
    
    # Sets up the visual context and calls the draw method
    def render()
      # Check for positive dimensions before creating image
      if pixel_width <= 0
        raise StandardError.new('Document cannot have a zero or negative width')
      end
      if pixel_height <= 0
        raise StandardError.new('Document cannot have a zero or negative height')
      end
      
      # Create display and graphics context
      image = BufferedImage.new(
        pixel_width, pixel_height, BufferedImage::TYPE_INT_ARGB
      )
      graphics = image.getGraphics()
      
      # Delegate drawing to separate method
      draw(graphics)
      
      # Render children
      render_children(graphics)
      
      return image
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


    ####################################
    # Render
    ####################################
    
    # Draws the component to the display context.
    #
    # @param [Graphics2D] g  the graphics context.
    def draw(g)
    end
    
    # Renders each of the children and composes their images on this components
    # image.
    def render_children(g)
      children.each do |child|
        image = child.render()
        g.drawImage(image, nil, child.x, child.y)
      end
    end


    ####################################
    # Drawing Methods
    ####################################
    
    def extract_color(color)
      red = (color >> 16) & 0xFF
      green = (color >> 8) & 0xFF
      blue = color & 0xFF
      return red, green, blue
    end
    
    def draw_line(g, x1, y1, x2, y2, thickness, color, alpha)
      red, green, blue = *extract_color(color)
      g.setStroke(BasicStroke.new(thickness, BasicStroke::CAP_BUTT, BasicStroke::JOIN_MITER))
      g.setColor(Color.new(red.to_i, green.to_i, blue.to_i, (alpha*255).to_i))
      g.drawLine(x1, y1, x2, y2)
    end

    def draw_arc(g, x, y, width, height, start_angle, arc_angle, thickness, color, alpha)
      red, green, blue = *extract_color(color)
      g.setStroke(BasicStroke.new(thickness, BasicStroke::CAP_BUTT, BasicStroke::JOIN_MITER))
      g.setColor(Color.new(red.to_i, green.to_i, blue.to_i, (alpha*255).to_i))
      g.drawArc(x, y, width, height, start_angle, arc_angle)
    end
  end 
end

require 'mockdown/component/border'
require 'mockdown/component/container'
require 'mockdown/component/row'
require 'mockdown/component/column'

