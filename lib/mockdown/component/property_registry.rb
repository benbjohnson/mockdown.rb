module Mockdown
  class Component
    # This class stores properties for class-based components.
    class PropertyRegistry
      ############################################################################
      # Static Methods
      ############################################################################
      
      # 
      def self.method_missing(sym, *args, &block)
        @singleton ||= PropertyRegistry.new()
        @singleton.__send__ sym, *args, &block
      end
      

      ############################################################################
      # Constructor
      ############################################################################

      def initialize()
        @classes = {}
      end

      ############################################################################
      # Methods
      ############################################################################
    
      # Registers a property for a class.
      #
      # @param [Class] clazz      the reference to the component class.
      # @param [String] property  the property to register.
      def register(clazz, property)
        @classes[clazz] ||= {}
        @classes[clazz][property.name] = property
      end

      # Unregisters a property from a class.
      #
      # @param [Class] clazz      the reference to the component class.
      # @param [String] property  the property to register.
      def unregister(clazz, property)
        @classes[clazz] ||= {}
        @classes[clazz].delete(property.name)
      end

      # Retrieves a property declared by a Ruby class.
      #
      # @param [Class] clazz  the reference to the component class.
      # @param [String] name  the name of the property to retrieve.
      #
      # @return [Property]  the property with the given name.
      def get_property(clazz, name)
        @classes[clazz] ||= {}
        return @classes[clazz][name]
      end

      # Retrieves all properties for a class.
      #
      # @param [Class] clazz  the reference to the component class.
      #
      # @return [Hash]  a hash of properties for a class.
      def get_properties(clazz)
        @classes[clazz] ||= {}
        return @classes[clazz]
      end
    end
  end 
end

class Class
  def prop_accessor(name, type, options={})
    property = Mockdown::Component::Property.new(name.to_s, type, options)
    Mockdown::Component::PropertyRegistry.register(self, property)
  end
end