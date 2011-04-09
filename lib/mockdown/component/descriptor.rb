module Mockdown
  class Component
    # This class describes how to construct an instance of a component.
    # Descriptors can inherit from other descriptors or system component
    # classes.
    class Descriptor
      ##########################################################################
      # Constructor
      ##########################################################################
    
      def initialize(parent=nil)
        @parent   = parent
        @children = []
        @properties = {}
        @property_values = {}
      end
      

      ##########################################################################
      # Attributes
      ##########################################################################
      
      # The name of the descriptor. This is usually set by the loader.
      attr_accessor :name

      # The descriptor that this descriptor inherits from. When a descriptor
      # creates an instance of a component, it recursively calls it parent until
      # a system defined component class is reached.
      attr_accessor :parent
      
      # The properties to set on a component that is instantiated from this
      # descriptor.
      attr_accessor :property_values
      
      # A list of descriptors to be instantiated and added as children to a
      # component when created from this descriptor.
      attr_accessor :children
      
      
      ##########################################################################
      # Methods
      ##########################################################################
      
      #################################
      # Instantiation
      #################################
      
      # Creates a new instance of a component described by this descriptor.
      def create()
        instance = create_instance()
        set_instance_properties(instance)
        create_instance_children(instance)
        return instance
      end


      #################################
      # Children
      #################################
      
      # Adds a child descriptor.
      #
      # @param [Descriptor] child  the child descriptor to add.
      def add_child(child)
        @children << child
        child.parent = self
      end

      # Removes a child descriptor.
      #
      # @param [Descriptor] child  the child descriptor to remove.
      def remove_child(child)
        if @children.delete(child)
          child.parent = nil
        end
      end
      

      #################################
      # Properties
      #################################
      
      # Adds a property to the descriptor.
      #
      # @param [String] property  the property to add.
      def add_property(property)
        # Throw error if property is nil
        if property.nil?
          raise StandardError.new("Cannot add a nil property")
        end

        # Throw error if property already exists.
        if !@properties[name].nil?
          raise StandardError.new("Property already exists: #{property.name}")
        end
        
        @properties[property.name] = property
      end

      # Retrieves a property by name.
      #
      # @param [String] name  the name of the property to retrieve.
      #
      # @return  the property on this descriptor with the given name.
      def get_property(name)
        if @properties[name]
          return @properties[name]
        elsif parent.is_a?(Descriptor)
          return parent.get_property(name)
        else
          # Search class-based hierarchy
          clazz = parent
          while !clazz.nil?
            property = PropertyRegistry.get_property(clazz, name)
            if property
              return property
            end
            
            clazz = clazz.superclass
          end
        end
      end

      # Retrieves a hash of all properties.
      def get_properties()
        return @properties
      end


      # Sets the value of a property.
      #
      # @param [String] name   the name of the property to set.
      # @param [String] value  the value to set.
      def set_property_value(name, value)
        property = get_property(name)
        
        # Throw error if property doesn't exist
        if property.nil?
          raise StandardError.new("Property does not exist: #{name}")
        end

        # Throw error if property is not valid
        if !property.valid_input?(self, value)
          raise StandardError.new("Invalid #{property.type} value for '#{name}': '#{value}'")
        end

        # Set the property value
        property.set_value(self, value)
      end

      # Retrieves the value of a property.
      #
      # @param [String] name   the name of the property to retrieve.
      #
      # @return [Object]  the value that has been set for a given property.
      def get_property_value(name)
        property = get_property(name)
        
        # Throw error if property doesn't exist
        if property.nil?
          raise StandardError.new("Property does not exist: #{name}")
        end

        # Return the property value
        property.get_value(self)
      end


      # Sets the raw value of a property.
      #
      # @param [String] name   the name of the property to set.
      # @param [String] value  the raw value to set.
      def set_raw_property_value(name, value)
        @property_values[name] = value
      end

      # Retrieves the raw value of a property.
      #
      # @param [String] name   the name of the property to retrieve.
      #
      # @return [Object]  the raw value that has been set for a given property.
      def get_raw_property_value(name)
        return @property_values[name]
      end

      
      ##########################################################################
      protected
      ##########################################################################
      
      # Generates an instance from the parent descriptor or component class.
      def create_instance()
        # If the parent is a descriptor, defer instantiation to it.
        if parent.is_a?(Descriptor)
          instance = parent.create()
        # If the parent is a system component, instantiate it
        elsif is_subclass?(parent, Component)
          instance = parent.new()
        # If parent is anything else then throw an error.
        else
          raise StandardError.new("Cannot instantiate parent of descriptor: #{parent}")
        end
      end
      
      # Checks if a class is a subclass of another class.
      #
      # @param [Class] child   the expected child class.
      # @param [Class] parent  the class that is expected to be in the child's
      #                        hierarchy.
      # @return [Boolean]      whether the child is a subclass of the parent.
      def is_subclass?(child, parent)
        clazz = child
        while !clazz.nil?
          return true if clazz == parent
          clazz = clazz.superclass
        end
        return false
      end
      
      # Sets the properties specified by the descriptor onto a component
      # instance.
      def set_instance_properties(instance)
        # Add the properties of this descriptor and it's parents to the component
        descriptor = self
        while !descriptor.nil?
          instance.add_properties(descriptor.get_properties())
          descriptor = descriptor.parent.is_a?(Descriptor) ? descriptor.parent : nil
        end
        
        # Loop over properties and set them on instance
        if property_values
          property_values.each do |key, value|
            instance.set_property_value(key, get_property_value(key))
          end
        end
      end
      
      # Instantiates the descriptor's child descriptors and adds the child
      # components to the new instance of this descriptor.
      def create_instance_children(instance)
        # Add children to component
        if children
          children.each do |child|
            instance.add_child(child.create())
          end
        end
      end
    end
  end 
end