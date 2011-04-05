module Mockdown
  class Component
    # This class represents the base class for all standard containers: Row,
    # Column and Canvas. 
    class Container < Component
      ##########################################################################
      # Component Properties
      ##########################################################################

      register_property('gap', 'integer')

      register_property('align', 'string')
      register_property('valign', 'string')
    end
  end 
end