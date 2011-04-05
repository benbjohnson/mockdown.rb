require File.join(File.dirname(File.expand_path(__FILE__)), '../../spec_helper')

describe Mockdown::Component::PropertyRegistry do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @registry = Mockdown::Component::PropertyRegistry.new()
    @property = Mockdown::Component::Property.new('foo', 'string')
  end

  after do
    @registry = nil
    @property = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

  it 'should register a property' do
    @registry.register(Mockdown::Component, @property)
    @registry.get_property(Mockdown::Component, 'foo').should == @property
  end

  it 'should unregister a property' do
    @registry.register(Mockdown::Component, @property)
    @registry.unregister(Mockdown::Component, @property)
    @registry.get_property(Mockdown::Component, 'foo').should be_nil
  end

  it 'should retrieve all properties' do
    @registry.register(Mockdown::Component, Mockdown::Component::Property.new('foo', 'string'))
    @registry.register(Mockdown::Component, Mockdown::Component::Property.new('bar', 'integer'))
    properties = @registry.get_properties(Mockdown::Component)
    properties.keys.should == ['foo', 'bar']
  end
end
