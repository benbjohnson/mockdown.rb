java_import 'java.awt.image.BufferedImage'

module Mockdown
  # This class renders a Mockdown file to an image.
  class Renderer
    ############################################################################
    # Constructor
    ############################################################################
    
    def initialize()
    end
    
    
    ############################################################################
    # Methods
    ############################################################################
    
    # Renders a Mockdown file to an image.
    #
    # @param [String] input  the Mockdown file.
    # @param [Hash] output   the output file to render to.
    def render(input, output)

      # Determine root folder and filename
      name = File.basename(input, '.mkd')
      root = File.dirname(File.expand_path(input))
      
      # Create descriptor and instantiate component
      loader = Loader.new()
      loader.paths = [root]
      descriptor = loader.find(name)
      component = descriptor.create()
      
      # Layout and render component
      component.measure()
      component.layout()
      image = component.render()
      
      # Draw white background
      image = draw_background(image)
      
      # Send output image to a PNG file
      file = java.io.File.new(File.expand_path(output))
      javax.imageio.ImageIO.write(image, 'png', file)
    end


    ############################################################################
    # Protected Methods
    ############################################################################
    
    protected
    
    # Draws a white background behind an image.
    #
    # @param [BufferedImage] image  the image to add a background to.
    #
    # @return  a new image with a background.
    def draw_background(image)
      w = image.getWidth()
      h = image.getHeight()
      background = BufferedImage.new(
        w, h, BufferedImage::TYPE_INT_ARGB
      )
      
      graphics = background.createGraphics()
      graphics.setColor(java.awt.Color::WHITE)
      graphics.fillRect(0, 0, w, h)
      graphics.drawRenderedImage(image, nil)
      
      return background
    end
  end 
end