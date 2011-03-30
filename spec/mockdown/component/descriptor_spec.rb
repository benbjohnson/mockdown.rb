require File.join(File.dirname(File.expand_path(__FILE__)), '../../spec_helper')

describe Mockdown::Component::Descriptor do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @descriptor = Mockdown::Component::Descriptor.new()
    @descriptor.parent = Mockdown::Component
  end

  after do
    @descriptor = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

  #####################################
  # Create
  #####################################

  it 'should instantiate from parent class' do
    @descriptor.parent = Mockdown::Component::Row
    @descriptor.create().class.should == Mockdown::Component::Row
  end

  it 'should instantiate from parent descriptor' do
    parent = Mockdown::Component::Descriptor.new()
    parent.parent = Mockdown::Component::Column
    @descriptor.parent = parent
    @descriptor.create().class.should == Mockdown::Component::Column
  end

  it 'should throw error for nil parent' do
    @descriptor.parent = nil
    expect {@descriptor.create()}.
      to raise_error(StandardError, 'Cannot instantiate parent of descriptor: ')
  end

  it 'should throw error for non-class, non-descriptor parent' do
    @descriptor.parent = Hash
    expect {@descriptor.create()}.
      to raise_error(StandardError, 'Cannot instantiate parent of descriptor: Hash')
  end

  it 'should set properties on component' do
    @descriptor.properties = {'x' => 10, 'y' => 20}
    instance = @descriptor.create()
    instance.x.should == 10
    instance.y.should == 20
  end

  it 'should set properties on component from parent descriptor' do
    parent = Mockdown::Component::Descriptor.new(Mockdown::Component)
    parent.properties = {'x' => 10}
    @descriptor.parent = parent
    @descriptor.properties = {'y' => 20}
    instance = @descriptor.create()
    instance.x.should == 10
    instance.y.should == 20
  end

  it 'should add children to component' do
    @descriptor.children = [
      Mockdown::Component::Descriptor.new(Mockdown::Component::Row),
      Mockdown::Component::Descriptor.new(Mockdown::Component::Column)
    ]
    instance = @descriptor.create()
    instance.children.length == 2
    row, col = *instance.children
    row.class.should == Mockdown::Component::Row
    col.class.should == Mockdown::Component::Column
  end


  #####################################
  # Children
  #####################################
  
  it 'should add child descriptor' do
    child = Mockdown::Component::Descriptor.new()
    @descriptor.add_child(child)
    @descriptor.children.length.should == 1
    child.parent.should == @descriptor
  end

  it 'should remove child descriptor' do
    child = Mockdown::Component::Descriptor.new()
    @descriptor.add_child(child)
    @descriptor.remove_child(child)
    @descriptor.children.length.should == 0
    child.parent.should be_nil
  end


  #####################################
  # Properties
  #####################################

  it 'should add property' do
    property = Mockdown::Component::Property.new('foo', 'string')
    @descriptor.add_property(property)
    @descriptor.get_property('foo').should == property
  end

  it 'should set property value' do
    property = Mockdown::Component::Property.new('foo', 'string')
    @descriptor.add_property(property)
    @descriptor.set_property_value('foo', 'bar')
    @descriptor.get_property_value('foo').should == 'bar'
  end

  it 'should throw error when setting non-existant property' do
    expect {@descriptor.set_property_value('foo', 'bar')}.
      to raise_error(StandardError, 'Property does not exist: foo')
  end
end
