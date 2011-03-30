require File.join(File.dirname(File.expand_path(__FILE__)), '../spec_helper')

describe Mockdown::Component do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @component = Mockdown::Component.new()
  end

  after do
    @component = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

  #####################################
  # Properties
  #####################################
  
  it 'should add property' do
    property = Mockdown::Component::Property.new('foo', 'string')
    @component.add_property(property)
    @component.get_property('foo').should == property
  end
  
  it 'should set and get property value' do
    @component.add_property(Mockdown::Component::Property.new('foo', 'string'))
    @component.foo = 'bar'
    @component.foo.should == 'bar'
  end
  
  it 'should throw error when getting non-existant property' do
    expect {x = @component.foo}.
      to raise_error(StandardError, 'Property does not exist on component: foo')
  end

  it 'should throw error when setting non-existant property' do
    expect {@component.foo = 'bar'}.
      to raise_error(StandardError, 'Property does not exist on component: foo')
  end

  it 'should add class-based properties' do
    @component.get_property('x').should_not be_nil
    @component.get_property('y').should_not be_nil
    @component.get_property('width').should_not be_nil
    @component.get_property('height').should_not be_nil
  end

  
  #####################################
  # Children
  #####################################
  
  it 'should add child' do
    child = Mockdown::Component.new()
    @component.add_child(child)
    child.parent.should == @component
    @component.children.should == [child]
  end

  it 'should remove child' do
    child = Mockdown::Component.new()
    @component.add_child(child)
    @component.remove_child(child)
    child.parent.should be_nil
    @component.children.length.should == 0
  end


  #####################################
  # Display
  #####################################
  
  it 'should explicitly set width' do
    @component.width = 100
    @component.measure()
    @component.pixel_width.should == 100
  end

  it 'should limit minimum width' do
    @component.width = 50
    @component.min_width = 100
    @component.measure()
    @component.pixel_width.should == 100
  end

  it 'should limit maximum width' do
    @component.width = 150
    @component.max_width = 100
    @component.measure()
    @component.pixel_width.should == 100
  end

  
  it 'should explicitly set height' do
    @component.height = 100
    @component.measure()
    @component.pixel_height.should == 100
  end

  it 'should limit minimum height' do
    @component.height = 50
    @component.min_height = 100
    @component.measure()
    @component.pixel_height.should == 100
  end

  it 'should limit maximum height' do
    @component.height = 150
    @component.max_height = 100
    @component.measure()
    @component.pixel_height.should == 100
  end
end
