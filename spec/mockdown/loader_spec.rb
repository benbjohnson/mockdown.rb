require File.join(File.dirname(File.expand_path(__FILE__)), '../spec_helper')

describe Mockdown::Loader do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @loader = Mockdown::Loader.new()
    @descriptor = Mockdown::Component::Descriptor.new()
    @parser = mock()
  end

  after do
    @loader = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

  ######################################
  # System components
  ######################################

  it 'should find Row descriptor' do
    descriptor = @loader.find('row')
    descriptor.parent.should == Mockdown::Component::Row
  end

  it 'should find Column descriptor' do
    descriptor = @loader.find('col')
    descriptor.parent.should == Mockdown::Component::Column
  end


  ######################################
  # User-defined components
  ######################################

  it 'should find user-defined document' do
    @loader.paths = ['/tmp']
    IO.expects(:read).with('/tmp/foo.mkd').returns('%row')
    File.expects(:exists?).with('/tmp/foo.mkd').returns(true)
    Mockdown::Parser.expects(:new).returns(@parser)
    @parser.expects(:parse).with('%row').returns(@descriptor)
    
    descriptor = @loader.find('foo')
    descriptor.name.should == 'foo'
  end

  it 'should find user-defined component' do
    @loader.paths = ['/tmp']
    File.expects(:exists?).with('/tmp/foo.mkd').returns(false)
    File.expects(:exists?).with('/tmp/foo.mkx').returns(true)
    IO.expects(:read).with('/tmp/foo.mkx').returns('%row')
    Mockdown::Parser.expects(:new).returns(@parser)
    @parser.expects(:parse).with('%row').returns(@descriptor)
    
    descriptor = @loader.find('foo')
    descriptor.name.should == 'foo'
  end


  it 'should find with multiple paths' do
    @loader.paths = ['/tmp', '/usr/local']
    File.expects(:exists?).with('/tmp/foo.mkd').returns(false)
    File.expects(:exists?).with('/tmp/foo.mkx').returns(false)
    File.expects(:exists?).with('/usr/local/foo.mkd').returns(true)
    IO.expects(:read).with('/usr/local/foo.mkd').returns('%row')
    Mockdown::Parser.expects(:new).returns(@parser)
    @parser.expects(:parse).with('%row').returns(@descriptor)
    
    descriptor = @loader.find('foo')
    descriptor.name.should == 'foo'
  end

  it 'should error when loading component with name containing \'..\'' do
    @loader.paths = []
    expect {@loader.find('..:foo')}.
      to raise_error(StandardError, "Cannot specify '..' in a component name")
  end


  ######################################
  # Missing component
  ######################################

  it 'should error when descriptor not found and no paths set' do
    expect {@loader.find('foo')}.
      to raise_error(StandardError, "Cannot load component 'foo' because no load paths have been set")
  end

  it 'should error when descriptor not found' do
    @loader.paths = ['~', 'lib']
    expect {@loader.find('foo')}.
      to raise_error(StandardError, "Cannot load component 'foo' in paths: ~,lib")
  end
end
