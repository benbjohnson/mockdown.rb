require File.join(File.dirname(File.expand_path(__FILE__)), '../../spec_helper')

describe Mockdown::Component::Row do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @row = Mockdown::Component::Row.new()
    @a = Mockdown::Component.new(:width => 10, :height => 20)
    @b = Mockdown::Component.new(:width => 30, :height => 40)
    @c = Mockdown::Component.new(:width => 50, :height => 60)
    @row.add_child(@a)
    @row.add_child(@b)
    @row.add_child(@c)
  end

  after do
    @row = @a = @b = @c = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

  #####################################
  # Measurement
  #####################################

  it 'should implicitly set width to sum of children' do
    @row.measure()
    @row.pixel_width.should == 90
  end

  it 'should add gap to implicit width' do
    @row.gap = 3
    @row.measure()
    @row.pixel_width.should == 96
  end

  it 'should add padding to implicit width' do
    @row.padding_left  = 5
    @row.padding_right = 6
    @row.measure()
    @row.pixel_width.should == 101
  end

  it 'should restrict implicit width above minimum width' do
    @row.min_width = 100
    @row.measure()
    @row.pixel_width.should == 100
  end

  it 'should restrict implicit width below maximum width' do
    @row.max_width = 50
    @row.measure()
    @row.pixel_width.should == 50
  end

  it 'should implicitly set height to largest child' do
    @row.measure()
    @row.pixel_height.should == 60
  end

  it 'should add padding to implicit height' do
    @row.padding_top    = 5
    @row.padding_bottom = 6
    @row.measure()
    @row.pixel_height.should == 71
  end

  it 'should restrict implicit height above minimum height' do
    @row.min_height = 100
    @row.measure()
    @row.pixel_height.should == 100
  end

  it 'should restrict implicit height below maximum height' do
    @row.max_height = 50
    @row.measure()
    @row.pixel_height.should == 50
  end


  #####################################
  # Layout
  #####################################

  it 'should layout percent width children' do
    @a.update_properties(:width => nil, :percent_width => 20)
    @b.update_properties(:width => nil, :percent_width => 40)
    @row.width = 220
    @row.gap = 5
    @row.padding_left = 6
    @row.padding_right = 4
    @row.measure()
    @row.layout()
    @a.pixel_width.should == 50
    @b.pixel_width.should == 100
    @c.pixel_width.should == 50
  end

  it 'should layout percent height children' do
    @a.update_properties(:height => nil, :percent_height => 20)
    @b.update_properties(:height => nil, :percent_height => 40)
    @row.height = 210
    @row.gap = 5
    @row.padding_top = 6
    @row.padding_bottom = 4
    @row.measure()
    @row.layout()
    @a.pixel_height.should == 40
    @b.pixel_height.should == 80
    @c.pixel_height.should == 60
  end


  #####################################
  # Horizontal Position
  #####################################
  
  it 'should left align children' do
    @row.update_properties(:align => 'left', :width => 200, :gap => 5, :padding_left => 6, :padding_right => 4)
    @row.measure()
    @row.layout()
    @a.x.should == 6
    @b.x.should == 21
    @c.x.should == 56
  end
  
  it 'should center align children' do
    @row.update_properties(:align => 'center', :width => 200, :gap => 5, :padding_left => 6, :padding_right => 4)
    @row.measure()
    @row.layout()
    @a.x.should == 51
    @b.x.should == 66
    @c.x.should == 101
  end
  
  it 'should right align children' do
    @row.update_properties(:align => 'right', :width => 200, :gap => 5, :padding_left => 6, :padding_right => 4)
    @row.measure()
    @row.layout()
    @a.x.should == 96
    @b.x.should == 111
    @c.x.should == 146
  end


  #####################################
  # Vertical Position
  #####################################
  
  it 'should top align children' do
    @row.update_properties(:valign => 'top', :height => 200, :gap => 5, :padding_top => 6, :padding_bottom => 4)
    @row.measure()
    @row.layout()
    @a.y.should == 6
    @b.y.should == 6
    @c.y.should == 6
  end

  it 'should middle align children' do
    @row.update_properties(:valign => 'middle', :height => 200, :gap => 5, :padding_top => 6, :padding_bottom => 4)
    @row.measure()
    @row.layout()
    @a.y.should == 91
    @b.y.should == 81
    @c.y.should == 71
  end

  it 'should bottom align children' do
    @row.update_properties(:valign => 'bottom', :height => 200, :gap => 5, :padding_top => 6, :padding_bottom => 4)
    @row.measure()
    @row.layout()
    @a.y.should == 176
    @b.y.should == 156
    @c.y.should == 136
  end
end
