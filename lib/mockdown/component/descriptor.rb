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
      attr_accessor :properties
      
      # A list of descriptors to be instantiated and added as children to a
      # component when created from this descriptor.
      attr_accessor :children
      
      
      ##########################################################################
      # Methods
      ##########################################################################
      
      # Creates a new instance of a component described by this descriptor.
      def create()
        instance = create_instance()
        set_properties(instance)
        create_children(instance)
        return instance
      end

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
      def set_properties(instance)
        # Loop over properties and set them on instance
        if properties
          properties.each_pair do |key, value|
            instance.__send__("#{key.to_s}=", value)
          end
        end
      end
      
      # Instantiates the descriptor's child descriptors and adds the child
      # components to the new instance of this descriptor.
      def create_children(instance)
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