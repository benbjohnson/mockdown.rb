require File.join(File.dirname(File.expand_path(__FILE__)), '../spec_helper')

describe Mockdown::Loader do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @loader = Mockdown::Loader.new()
  end

  after do
    @loader = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

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
end
