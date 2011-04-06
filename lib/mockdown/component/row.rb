module Mockdown
  class Component
    # This class represents a container that lays out its children horizontally.
    class Row < Container
      ##########################################################################
      # Methods
      ##########################################################################
      
      def layout()
        layout_percent_children()
        #layout_child_positions()
        super()
      end


      ##########################################################################
      # Protected Methods
      ##########################################################################
      
      #################################
      # Measurement
      #################################

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

      #################################
      # Layout
      #################################

      def layout_percent_children()
        last_percent_child = nil
        
        # Determine explicit width of children
        total_explicit_width = children.inject(0) do |memo, child|
          memo + (child.width || 0)
        end

        # Determine percentage width of children
        total_percent_width = children.inject(0) do |memo, child|
          memo + (child.percent_width || 0)
        end
        
        # Determine left over width
        total_gap = gap * (children.length-1)
        total_remaining = pixel_width - total_explicit_width - total_gap;
        total_remaining -= padding_left + padding_right;
        remaining = total_remaining
        
        # Calculate percent width & height for children
        children.each do |child|
          # Calculate percentage width
          if !child.percent_width.nil?
            if total_remaining > 0
              child_pixel_width = ((child.percent_width.to_f/total_percent_width) * total_remaining).round
    					child.pixel_width = [remaining, child_pixel_width].min
    					remaining -= child.pixel_width
    					last_percent_child = child
            end
          end

          # Calculate percentage height
          if !child.percent_height.nil?
            child.pixel_height = ((child.percent_height/100.0) * (pixel_height - padding_top - padding_bottom)).round
          end
        end

        # Add remaining pixels to last percentage child
        if !last_percent_child.nil? && remaining != 0
          last_percent_child += remaining
        end
      end
    end
  end 
end