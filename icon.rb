# FIE!!! FIE ON YOU ALL!!!!!
# FOUL FOUL FIENDS OF FOULNESS!!!!
# AAAARRRRRRGGGGGGGGGHHHHHHHHHHHHHHHH!!!!!!!!

require 'gosu'
require 'texplay'
require 'pry'

class W < Gosu::Window
  def initialize
    super 500, 500, false

    self.caption = "icon"

    @img = Gosu::Image.new( self, "img/triangle.png")

  end

  def fold image
    width, height = image.width.to_f, image.height.to_f
    img = TexPlay.create_image(self, width, height)
    # some demi-constants
    a = 1.4
    b = 0.3
    puts 'in fold'
    image.each do |pix, x, y|
      #next if pix[3] == 0.0
      x, y = ((x/width)-0.5)*2, ((y/height)-0.5)*2
      dx = y + 1 -a * x**2
      dy = b*x
      next if  (dx.abs2 >= 1.0) || (dy.abs2 >= 1.0) # abs2 is prolly slightly faster
      #binding.pry
      img.pixel (((dx*2)+0.5)*width).to_i, (((dy*2)+0.5)*height).to_i, pix
    end
    puts 'done with fold'
    img
  end

  def draw
    @img.draw 0, 0, 1
  end

  def update
    if button_down? Gosu::KbRight
      @img = fold @img
    end
  end

end

w = W.new
w.show

