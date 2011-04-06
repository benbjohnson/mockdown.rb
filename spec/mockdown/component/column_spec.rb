require File.join(File.dirname(File.expand_path(__FILE__)), '../../spec_helper')

describe Mockdown::Component::Column do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @col = Mockdown::Component::Column.new()
    @a = Mockdown::Component.new(:width => 20, :height => 10)
    @b = Mockdown::Component.new(:width => 40, :height => 30)
    @c = Mockdown::Component.new(:width => 60, :height => 50)
    @col.add_child(@a)
    @col.add_child(@b)
    @col.add_child(@c)
  end

  after do
    @col = @a = @b = @c = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

  #####################################
  # Measurement
  #####################################

  it 'should implicitly set width to largest child' do
    @col.measure()
    @col.pixel_width.should == 60
  end

  it 'should add padding to implicit width' do
    @col.padding_left  = 5
    @col.padding_right = 6
    @col.measure()
    @col.pixel_width.should == 71
  end

  it 'should restrict implicit width above minimum width' do
    @col.min_width = 100
    @col.measure()
    @col.pixel_width.should == 100
  end

  it 'should restrict implicit width below maximum width' do
    @col.max_width = 50
    @col.measure()
    @col.pixel_width.should == 50
  end


  it 'should implicitly set height to sum of children' do
    @col.measure()
    @col.pixel_height.should == 90
  end

  it 'should add gap to implicit height' do
    @col.gap = 3
    @col.measure()
    @col.pixel_height.should == 96
  end

  it 'should add padding to implicit height' do
    @col.padding_top  = 5
    @col.padding_bottom = 6
    @col.measure()
    @col.pixel_height.should == 101
  end

  it 'should restrict implicit height above minimum height' do
    @col.min_height = 100
    @col.measure()
    @col.pixel_height.should == 100
  end

  it 'should restrict implicit height below maximum height' do
    @col.max_height = 50
    @col.measure()
    @col.pixel_height.should == 50
  end



  #####################################
  # Layout
  #####################################

  it 'should layout percent height children' do
    @a.update_properties(:height => nil, :percent_height => 20)
    @b.update_properties(:height => nil, :percent_height => 40)
    @col.height = 220
    @col.gap = 5
    @col.padding_top = 6
    @col.padding_bottom = 4
    @col.measure()
    @col.layout()
    @a.pixel_height.should == 50
    @b.pixel_height.should == 100
    @c.pixel_height.should == 50
  end

  it 'should layout percent width children' do
    @a.update_properties(:width => nil, :percent_width => 20)
    @b.update_properties(:width => nil, :percent_width => 40)
    @col.width = 210
    @col.gap = 5
    @col.padding_left = 6
    @col.padding_right = 4
    @col.measure()
    @col.layout()
    @a.pixel_width.should == 40
    @b.pixel_width.should == 80
    @c.pixel_width.should == 60
  end


  #####################################
  # Horizontal Position
  #####################################
  
  it 'should left align children' do
    @col.update_properties(:align => 'left', :width => 200, :gap => 5, :padding_left => 6, :padding_right => 4)
    @col.measure()
    @col.layout()
    @a.x.should == 6
    @b.x.should == 6
    @c.x.should == 6
  end

  it 'should center align children' do
    @col.update_properties(:align => 'center', :width => 200, :gap => 5, :padding_left => 6, :padding_right => 4)
    @col.measure()
    @col.layout()
    @a.x.should == 91
    @b.x.should == 81
    @c.x.should == 71
  end

  it 'should right align children' do
    @col.update_properties(:align => 'right', :width => 200, :gap => 5, :padding_left => 6, :padding_right => 4)
    @col.measure()
    @col.layout()
    @a.x.should == 176
    @b.x.should == 156
    @c.x.should == 136
  end


  #####################################
  # Vertical Position
  #####################################
  
  it 'should top align children' do
    @col.update_properties(:valign => 'top', :height => 200, :gap => 5, :padding_top => 6, :padding_bottom => 4)
    @col.measure()
    @col.layout()
    @a.y.should == 6
    @b.y.should == 21
    @c.y.should == 56
  end
  
  it 'should middle align children' do
    @col.update_properties(:valign => 'middle', :height => 200, :gap => 5, :padding_top => 6, :padding_bottom => 4)
    @col.measure()
    @col.layout()
    @a.y.should == 51
    @b.y.should == 66
    @c.y.should == 101
  end
  
  it 'should bottom align children' do
    @col.update_properties(:valign => 'bottom', :height => 200, :gap => 5, :padding_top => 6, :padding_bottom => 4)
    @col.measure()
    @col.layout()
    @a.y.should == 96
    @b.y.should == 111
    @c.y.should == 146
  end
end
