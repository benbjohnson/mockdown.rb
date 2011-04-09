module Mockdown
  class Component
    # This class describes a property that combines multiple properties.
    class CompositeProperty
      ##########################################################################
      # Constructor
      ##########################################################################
    
      def initialize(name, format, options={})
        # Change array-based formats into a multi-property format
        if format.is_a?(Array)
          format = format.join(',')
        end
        
        @name = name
        @properties = format.split(' ').map{|property| property.split(/,/)}
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
          break if index > values.length-1
          subproperties = @properties[index]

          subproperties.each do |subproperty|
            owner.set_property_value(subproperty, values[index])
          end
        end
      end

      # Retrieves and formats a value into the data type of this property. If
      # a multi-value property is used, all subvalues must be the same to return
      # a value. If they are different then a blank string is returned.
      #
      # @param [Object] owner  the owner of this property.
      #
      # @return  the formatted value.
      def get_value(owner)
        values = []
        
        # If any subvalues do not all equal each other, return a blank string back
        @properties.each do |subproperties|
          subvalue = nil
          subproperties.each do |subproperty|
            value = owner.get_property_value(subproperty)
            subvalue ||= value
            return "" if value == '' || subvalue != value
          end

          values << subvalue
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
        
        # Check each property for validity
        values = value.to_s.split(/ +/)

        @properties.each_index do |index|
          break if index > values.length-1
          subproperties = @properties[index]

          subproperties.each do |subproperty|
            property = owner.get_property(subproperty)

            if !property.valid_input?(owner, values[index])
              return false
            end
          end
        end
        
        return true
      end
    end
  end 
end