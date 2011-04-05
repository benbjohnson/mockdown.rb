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
  # Layout
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

  it 'should implicitly set width to largest child' do
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
end
