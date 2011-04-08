java_import 'java.awt.BasicStroke'
java_import 'java.awt.Color'
java_import 'java.awt.Rectangle'
java_import 'java.awt.image.BufferedImage'

module Mockdown
  # This class represents a component which can draw a border and background.
  class Border < Component
    ############################################################################
    # Component Properties
    ############################################################################

    composite_prop_accessor :border, 'border_thickness border_color border_alpha'

    prop_accessor :border_thickness, 'length', :default => '0px'
    prop_accessor :border_color, 'color', :default => '#000000'
    prop_accessor :border_alpha, 'percent', :default => '100%'
    

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
      thickness = border_thickness!
      color = border_color!
      alpha = border_alpha!

      red = (color >> 16) & 0xFF
      green = (color >> 8) & 0xFF
      blue = color & 0xFF
      g.setStroke(BasicStroke.new(thickness))
      g.setColor(Color.new(red.to_i, green.to_i, blue.to_i, (alpha*255).to_i))

      rect = Rectangle.new(thickness/2, thickness/2, pixel_width-thickness, pixel_height-thickness)
      g.draw(rect)
    end
  end 
end
