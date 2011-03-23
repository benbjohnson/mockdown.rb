require File.join(File.dirname(File.expand_path(__FILE__)), '../../spec_helper')

describe Mockdown::Parser::Builder do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @builder = Mockdown::Parser::Builder.new()
    @a = Mockdown::Component::Descriptor.new()
    @b = Mockdown::Component::Descriptor.new()
    @c = Mockdown::Component::Descriptor.new()
    @d = Mockdown::Component::Descriptor.new()
  end

  after do
    @builder = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

  it 'should add root descriptor' do
    @builder.add(@a, 0)
    @builder.descriptor.should == @a
  end

  it 'should add a child descriptor' do
    @builder.add(@a, 0)
    @builder.add(@b, 1)
    @builder.add(@c, 2)
    @builder.add(@d, 1)
    descriptor = @builder.descriptor
    descriptor.should == @a
    descriptor.children.length.should == 2
    descriptor.children[0].should == @b
    descriptor.children[0].children.length.should == 1
    descriptor.children[0].children[0].should == @c
    descriptor.children[1].should == @d
  end

  it 'should raise error when setting two root descriptors' do
    @builder.add(@a, 0)
    expect {@builder.add(@b, 0)}.
      to raise_error(StandardError, 'Cannot have two root components on a document')
  end

  it 'should raise error when adding nested component without root defined' do
    expect {@builder.add(@a, 1)}.
      to raise_error(StandardError, 'Root component not defined')
  end

  it 'should raise error when adding nested component too deep' do
    @builder.add(@a, 0)
    expect {@builder.add(@b, 2)}.
      to raise_error(StandardError, 'Component level specified is too deep')
  end
end
