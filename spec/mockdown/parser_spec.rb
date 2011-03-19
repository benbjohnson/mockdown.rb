require File.join(File.dirname(File.expand_path(__FILE__)), '../spec_helper')

describe Mockdown::Parser do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @parser = Mockdown::Parser.new()
  end

  after do
    @parser = nil
  end


  ##############################################################################
  # Tests
  ##############################################################################

  it 'should create simple component' do
    pending
    
    IO.expects(:read).with('test.mkd').returns(
      <<-BLOCK.unindent
      %row
      BLOCK
    )
    
    component = @parser.parse('test')
    component.name.should == 'test'
    component.superclass.should == Mockdown::Component::Row
  end
end
