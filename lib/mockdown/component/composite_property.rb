module Mockdown
  class Component
    # This class describes a property that combines multiple properties.
    class CompositeProperty
      ##########################################################################
      # Constructor
      ##########################################################################
    
      def initialize(name, format, options={})
        @name = name
        @properties = format.split(' ')
        @default = options.delete(:default)
      end
      

      ##########################################################################
      # Attributes
      ##########################################################################
      
      # The name of the property on the component.
      attr_reader :name
      
      # The default value of the property.
      attr_reader :default
      
      
      ##########################################################################
      # Methods
      ##########################################################################
      
      # Parses the a value into the data type of this property.
      #
      # @param [Object] value  the value to parse.
      #
      # @return  the value converted to this property's data type.
      def set_value(owner, value)
        values = value.to_s.split(/ +/)

        @properties.each_index do |index|
          property_name = @properties[index]
          break if index > values.length-1
          owner.set_property_value(property_name, values[index])
        end
      end

      # Retrieves and formats a value into the data type of this property.
      #
      # @param [Object] owner  the owner of this property.
      #
      # @return  the formatted value.
      def get_value(owner)
        values = []
        
        @properties.each do |property_name|
          values << owner.get_property_value(property_name)
        end
        
        return values.join(' ')
      end

      # Checks if a given string value valid for the property's data type.
      #
      # @param [Object] value  the string to validate.
      #
      # @return [Boolean]  true, if string is valid. Otherwise false.
      def valid_input?(owner, value)
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