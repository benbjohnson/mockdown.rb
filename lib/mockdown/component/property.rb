module Mockdown
  class Component
    # This class describes a property added to a component.
    class Property
      ##########################################################################
      # Static Methods
      ##########################################################################
      
      # Determines if the type is a standard type.
      #
      # @param [String] type  the name of the type.
      #
      # @return [Boolean]  whether the type is valid.
      def self.valid_type?(type)
        return (type == 'string' || type == 'integer' || type == 'decimal')
      end
    
    
      ##########################################################################
      # Constructor
      ##########################################################################
    
      def initialize(name, type)
        # Validate type
        if !Property.valid_type?(type)
          raise StandardError.new("Invalid data type for '#{name}' property: #{type}")
        end
        
        @name = name
        @type = type
      end
      

      ##########################################################################
      # Attributes
      ##########################################################################
      
      # The name of the property on the component.
      attr_reader :name
      
      # The data type of the property.
      attr_reader :type
      
      
      ##########################################################################
      # Methods
      ##########################################################################
      
      # Parses the a value into the data type of this property.
      #
      # @param [Object] value  the value to parse.
      #
      # @return  the value converted to this property's data type.
      def parse(value)
        case type
        when 'string' then value.to_s
        when 'integer' then value.to_i
        when 'decimal' then value.to_f
        end
      end

      # Checks if a given string value valid for the property's data type.
      #
      # @param [Object] value  the string to validate.
      #
      # @return [Boolean]  true, if string is valid. Otherwise false.
      def valid_input?(value)
        if value.nil?
          raise StandardError.new("Cannot validate null value")
        end
        
        # Convert to string first
        value = value.to_s
        
        # Match depending on type
        case type
        when 'string' then true
        when 'integer' then !value.match(/^-?\d+?$/).nil?
        when 'decimal' then !value.match(/^-?\d+(\.\d+)?$/).nil?
        end
      end
    end
  end 
end