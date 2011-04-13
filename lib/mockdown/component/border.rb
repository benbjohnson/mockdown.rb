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
    

    composite_prop_accessor :border_radius,
      [
        'border_top_left_radius',
        'border_top_right_radius',
        'border_bottom_left_radius',
        'border_bottom_right_radius'
      ]
    prop_accessor :border_top_left_radius, 'length', :default => '0px'
    prop_accessor :border_top_right_radius, 'length', :default => '0px'
    prop_accessor :border_bottom_left_radius, 'length', :default => '0px'
    prop_accessor :border_bottom_right_radius, 'length', :default => '0px'


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

      # Save half thicknesses for convenience
      half_btt = (btt/2.0).round
      half_bbt = (bbt/2.0).round
      half_blt = (blt/2.0).round
      half_brt = (brt/2.0).round

      btlr = border_top_left_radius!
      btrr = border_top_right_radius!
      bblr = border_bottom_left_radius!
      bbrr = border_bottom_right_radius!

      # Top border
      if(btt > 0)
        if btlr
          draw_arc(g,
            half_blt, half_btt,
            (btlr*2)-blt, (btlr*2)-btt,
            90, 90,
            btt, border_top_color!, border_top_alpha!
          )
        end
        
        draw_line(g,
          btlr, (btt/2),
          pixel_width - btrr, (btt/2),
          btt, border_top_color!, border_top_alpha!
        )
      end
      
      # Right border
      if(brt > 0)
        if btrr
          draw_arc(g,
            pixel_width-(btrr*2)+(blt/2), half_btt,
            (btrr*2)-brt, (btrr*2)-btt,
            0, 90,
            brt, border_right_color!, border_right_alpha!
          )
        end
        
        draw_line(g,
          pixel_width - half_brt, btrr,
          pixel_width - half_brt, pixel_height - btrr,
          btt, border_right_color!, border_right_alpha!
        )
      end
      
      # Bottom border
      if(bbt > 0)
        if bbrr
          draw_arc(g,
            pixel_width-(bbrr*2)+(blt/2), pixel_height-(bbrr*2)+(bbt/2),
            (bbrr*2)-brt, (bbrr*2)-bbt,
            270, 90,
            bbt, border_bottom_color!, border_bottom_alpha!
          )
        end
        
        draw_line(g,
          bblr, pixel_height-half_bbt,
          pixel_width - bbrr, pixel_height-half_bbt,
          bbt, border_bottom_color!, border_bottom_alpha!
        )
      end
      
      # Left border
      if(blt > 0)
        if bblr
          draw_arc(g,
            half_blt, pixel_height-(bblr*2)+half_bbt,
            (bblr*2)-brt, (bblr*2)-bbt,
            180, 90,
            blt, border_left_color!, border_left_alpha!
          )
        end
        
        draw_line(g,
          (blt/2), btlr,
          (blt/2), pixel_height - bblr,
          blt, border_left_color!, border_left_alpha!
        )
      end
    end
  end 
end
