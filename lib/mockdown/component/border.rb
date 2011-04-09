module Mockdown
  # This class represents a component which can draw a border and background.
  class Border < Component
    ############################################################################
    # Component Properties
    ############################################################################

    composite_prop_accessor :border, 'border_thickness border_color border_alpha'

    composite_prop_accessor :border_thickness, 
      [
        'border_top_thickness',
        'border_bottom_thickness',
        'border_left_thickness',
        'border_right_thickness'
      ]

    composite_prop_accessor :border_color,
      [
        'border_top_color',
        'border_bottom_color',
        'border_left_color',
        'border_right_color'
      ]

    composite_prop_accessor :border_alpha,
      [
        'border_top_alpha',
        'border_bottom_alpha',
        'border_left_alpha',
        'border_right_alpha'
      ]

    composite_prop_accessor :border_top, 'border_top_thickness border_top_color border_top_alpha'
    prop_accessor :border_top_thickness, 'length', :default => '0px'
    prop_accessor :border_top_color, 'color', :default => '#000000'
    prop_accessor :border_top_alpha, 'percent', :default => '100%'

    composite_prop_accessor :border_bottom, 'border_bottom_thickness border_bottom_color border_bottom_alpha'
    prop_accessor :border_bottom_thickness, 'length', :default => '0px'
    prop_accessor :border_bottom_color, 'color', :default => '#000000'
    prop_accessor :border_bottom_alpha, 'percent', :default => '100%'

    composite_prop_accessor :border_left, 'border_left_thickness border_left_color border_left_alpha'
    prop_accessor :border_left_thickness, 'length', :default => '0px'
    prop_accessor :border_left_color, 'color', :default => '#000000'
    prop_accessor :border_left_alpha, 'percent', :default => '100%'

    composite_prop_accessor :border_right, 'border_right_thickness border_right_color border_right_alpha'
    prop_accessor :border_right_thickness, 'length', :default => '0px'
    prop_accessor :border_right_color, 'color', :default => '#000000'
    prop_accessor :border_right_alpha, 'percent', :default => '100%'
    

    ############################################################################
    # Methods
    ############################################################################
    
    def draw(g)
      draw_border(g)
    end
    
    
    ############################################################################
    # Protected Methods
    ############################################################################

    protected
    
    def draw_border(g)
      # Save thicknesses for performance
      btt = border_top_thickness!
      bbt = border_bottom_thickness!
      blt = border_left_thickness!
      brt = border_right_thickness!

      # Top border
      if(btt > 0)
        draw_line(g,
          0, (btt/2),
          pixel_width, (btt/2),
          btt, border_top_color!, border_top_alpha!
        )
      end
      
      # Right border
      if(brt > 0)
        draw_line(g,
          pixel_width-(brt/2), 0,
          pixel_width-(brt/2), pixel_height,
          brt, border_right_color!, border_right_alpha!
        )
      end
      
      # Bottom border
      if(bbt > 0)
        draw_line(g,
          pixel_width, pixel_height-(bbt/2),
          0, pixel_height-(bbt/2),
          bbt, border_bottom_color!, border_bottom_alpha!
        )
      end
      
      # Left border
      if(blt > 0)
        draw_line(g,
          blt/2, pixel_height,
          blt/2, 0,
          blt, border_left_color!, border_left_alpha!
        )
      end
    end
  end 
end
