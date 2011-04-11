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

      tlr = border_top_left_radius!
      trr = border_top_right_radius!
      blr = border_bottom_left_radius!
      brr = border_bottom_right_radius!

      # Top border
      if(btt > 0)
        if tlr
          draw_arc(g,
            0, 0,
            tlr*2, tlr*2,
            90, 45,
            btt, border_top_color!, border_top_alpha!
          )
        end
        
        draw_line(g,
          0 + tlr, (btt/2),
          pixel_width - trr, (btt/2),
          btt, border_top_color!, border_top_alpha!
        )

        if trr
          draw_arc(g,
            pixel_width-trr*2, 0,
            trr*2, trr*2,
            45, 45,
            btt, border_top_color!, border_top_alpha!
          )
        end
      end
      
      # Right border
      if(brt > 0)
        if trr
          draw_arc(g,
            pixel_width-(trr*2), 0,
            trr*2, trr*2,
            0, 45,
            btt, border_right_color!, border_right_alpha!
          )
        end

        draw_line(g,
          pixel_width-(brt/2), trr,
          pixel_width-(brt/2), pixel_height - brr,
          brt, border_right_color!, border_right_alpha!
        )

        if brr
          draw_arc(g,
            pixel_width-(brr*2)-1, pixel_height-(brr*2)-1,
            brr*2, brr*2,
            315, 45,
            btt, border_right_color!, border_right_alpha!
          )
        end
      end
      
      # Bottom border
      if(bbt > 0)
        if brr
          draw_arc(g,
            pixel_width-(brr*2)-1, pixel_height-(brr*2)-1,
            brr*2, brr*2,
            270, 45,
            btt, border_bottom_color!, border_bottom_alpha!
          )
        end

        draw_line(g,
          pixel_width - brr, pixel_height-(bbt/2),
          blr, pixel_height-(bbt/2),
          bbt, border_bottom_color!, border_bottom_alpha!
        )

        if blr
          draw_arc(g,
            0, pixel_height-(brr*2)-1,
            blr*2, blr*2,
            225, 45,
            btt, border_bottom_color!, border_bottom_alpha!
          )
        end
      end
      
      # Left border
      if(blt > 0)
        if blr
          draw_arc(g,
            0, pixel_height-(brr*2)-1,
            blr*2, blr*2,
            180, 45,
            btt, border_left_color!, border_left_alpha!
          )
        end

        draw_line(g,
          blt/2, pixel_height - blr,
          blt/2, tlr,
          blt, border_left_color!, border_left_alpha!
        )

        if tlr
          draw_arc(g,
            0, 0,
            tlr*2, tlr*2,
            135, 45,
            btt, border_left_color!, border_left_alpha!
          )
        end
      end
    end
  end 
end
