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

  it 'should parse simple document' do
    descriptor = @parser.parse(
      <<-BLOCK.unindent
      %row
      BLOCK
    )
    descriptor.parent.should == Mockdown::Component::Row
  end
end
