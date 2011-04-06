module Mockdown
  class Component
    # This class describes a property added to a component.
    class Property
      ##########################################################################
      # Static Methods
      ##########################################################################
      
      @@types = ['string', 'integer', 'decimal', 'length', 'color', 'percent']
      
      # Determines if the type is a standard type.
      #
      # @param [String] type  the name of the type.
      #
      # @return [Boolean]  whether the type is valid.
      def self.valid_type?(type)
        return !@@types.index(type).nil?
      end
    
    
      ##########################################################################
      # Constructor
      ##########################################################################
    
      def initialize(name, type, options={})
        # Validate type
        if !Property.valid_type?(type)
          raise StandardError.new("Invalid data type for '#{name}' property: #{type}")
        end
        
        @name = name
        @type = type
        @default = options.delete(:default)
      end
      

      ##########################################################################
      # Attributes
      ##########################################################################
      
      # The name of the property on the component.
      attr_reader :name
      
      # The data type of the property.
      attr_reader :type

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
        raw_value = case type
        when 'string' then value.to_s
        when 'integer' then value.to_i
        when 'decimal' then value.to_f
        when 'length' then value.to_i
        when 'color' then value[1..-1].to_i(16)
        when 'percent' then value.to_f/100
        end

        owner.set_raw_property_value(name, raw_value)
      end

      # Retrieves and formats a value into the data type of this property.
      #
      # @param [Object] owner  the owner of this property.
      #
      # @return  the formatted value.
      def get_value(owner)
        raw_value = owner.get_raw_property_value(name)

        case type
        when 'string' then raw_value
        when 'integer' then raw_value
        when 'decimal' then raw_value
        when 'length' then "#{raw_value}px"
        when 'color' then "##{raw_value}"
        when 'percent' then "#{(raw_value*100).to_f}%"
        end
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
        when 'integer' then !value.match(/^-?\d+$/).nil?
        when 'decimal' then !value.match(/^-?\d+(\.\d+)?$/).nil?
        when 'length' then !value.match(/^-?\d+(px)?$/).nil?
        when 'color' then !value.match(/^#[0-9A-F]{6}$/i).nil?
        when 'percent' then !value.match(/^-?\d+(\.\d+)?%$/).nil?
        end
      end
    end
  end 
end