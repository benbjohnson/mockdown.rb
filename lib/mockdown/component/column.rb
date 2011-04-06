module Mockdown
  class Component
    # This class represents a container that lays out its children vertically.
    class Column < Container
      ##########################################################################
      # Methods
      ##########################################################################
      
      def layout()
        layout_percent_children()
        layout_child_positions()
        super()
      end


      ##########################################################################
      # Protected Methods
      ##########################################################################
      
      #################################
      # Measurement
      #################################

      def measure_implicit()
        # Calculate width as the maximum child width + padding
        if width.nil?
          # Set width to largest child
          w = children.map{|child| child.pixel_width}.max || 0
        
          # Add padding
          w += padding_left + padding_right
          
  			  # Restrict min/max
  			  self.pixel_width = Math.limit(w, min_width, max_width)
        end

        # Calculate height as sum of child height + padding + gaps
        if height.nil?
          # Sum widths of children
          h = children.inject(0) {|memo, child| memo+(child.pixel_height||0)}
          
          # Add padding and gaps
          h += padding_top + padding_bottom
			    h += gap * (children.length-1);
			
  			  # Restrict min/max
  			  self.pixel_height = Math.limit(h, min_height, max_height)
        end
      end


      #################################
      # Layout
      #################################

      # Lays out the variable height children.
      def layout_percent_children()
        last_percent_child = nil
        
        # Determine explicit height of children
        total_explicit_height = children.inject(0) do |memo, child|
          memo + (child.height || 0)
        end

        # Determine percentage height of children
        total_percent_height = children.inject(0) do |memo, child|
          memo + (child.percent_height || 0)
        end
        
        # Determine leftover height
        total_gap = gap * (children.length-1)
        total_remaining = pixel_height - total_explicit_height - total_gap;
        total_remaining -= padding_top + padding_bottom;
        remaining = total_remaining
        
        # Calculate percent width & height for children
        children.each do |child|
          # Calculate percentage width
          if !child.percent_width.nil?
            child.pixel_width = ((child.percent_width/100.0) * (pixel_width - padding_left - padding_right)).round
          end

          # Calculate percentage height
          if !child.percent_height.nil?
            if total_remaining > 0
              child_pixel_height = ((child.percent_height.to_f/total_percent_height) * total_remaining).round
    					child.pixel_height = [remaining, child_pixel_height].min
    					remaining -= child.pixel_height
    					last_percent_child = child
            end
          end
        end

        # Add remaining pixels to last percentage child
        if !last_percent_child.nil? && remaining != 0
          last_percent_child.pixel_height += remaining
        end
      end
      
      
      # Calculates x and y positions for each child.
      def layout_child_positions()
        # Calculate total height + gap
        total = children.inject(0) {|memo, child| memo+(child.pixel_height||0)}
        total += gap * (children.length-1)
        
        # Position children
        pos = 0
        
        children.each do |child|
          # Y Position
          child.y = case valign
          when 'bottom' then
            pixel_height - total - padding_bottom + pos;
          when 'middle' then
				    (((pixel_height-padding_top-padding_bottom).to_f/2) - (total.to_f/2) + pos + padding_top).round;
          else
				    padding_top + pos;
          end

          # X Position
          child.x = case align
          when 'right' then
            pixel_width - padding_right - child.pixel_width;
          when 'center' then
				    (((pixel_width-padding_left-padding_right).to_f/2) - (child.pixel_width.to_f/2) + padding_left).round;
          else
				    padding_left
          end

    			# Increment current position by child height and gap
    			pos += child.pixel_height + gap;
        end
      end
    end
  end 
end