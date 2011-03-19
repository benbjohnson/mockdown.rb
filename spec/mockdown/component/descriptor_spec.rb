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
  # Instantiation
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


  #####################################
  # Properties
  #####################################

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


  #####################################
  # Children
  #####################################

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
end
