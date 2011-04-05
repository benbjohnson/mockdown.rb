module Mockdown
  class Component
    # This class represents the base class for all standard containers: Row,
    # Column and Canvas. 
    class Container < Component
      ##########################################################################
      # Component Properties
      ##########################################################################

      prop_accessor :gap, 'integer', :default => 0

      prop_accessor :align, 'string', :default => 'left'
      prop_accessor :valign, 'string', :default => 'top'

      prop_accessor :padding_top, 'integer', :default => 0
      prop_accessor :padding_bottom, 'integer', :default => 0
      prop_accessor :padding_left, 'integer', :default => 0
      prop_accessor :padding_right, 'integer', :default => 0


      ##########################################################################
      # Methods
      ##########################################################################

      # Lays out child components.
      def layout()
        layout_children()
      end


      ##########################################################################
      # Protected Methods
      ##########################################################################
      
      def layout_children()
        children.each do |child|
          child.layout()
        end
      end
    end
  end 
end