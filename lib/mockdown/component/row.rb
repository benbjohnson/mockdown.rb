module Mockdown
  class Component
    # This class represents a container that lays out its children horizontally.
    class Row < Container
      ##########################################################################
      # Protected Methods
      ##########################################################################
      
      def measure_implicit()
        # Calculate width as sum of child widths + padding + gaps
        if width.nil?
          # Sum widths of children
          w = children.inject(0) {|memo, child| memo+(child.pixel_width||0)}
          
          # Add padding and gaps
          w += padding_left + padding_right
			    w += gap * (children.length-1);
			
  			  # Restrict min/max
  			  self.pixel_width = Math.limit(w, min_width, max_width)
        end

        # Calculate height as the maximum child height + padding
        if height.nil?
          # Set height to largest child
          h = children.map{|child| child.pixel_height}.max || 0
        
          # Add padding
          h += padding_top + padding_bottom
          
  			  # Restrict min/max
  			  self.pixel_height = Math.limit(h, min_height, max_height)
        end
      end
    end
  end 
end