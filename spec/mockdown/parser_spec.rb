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

  it 'should parse a component name' do
    descriptor = @parser.parse(
      <<-BLOCK.unindent
      %row
      BLOCK
    )
    descriptor.parent.should == Mockdown::Component::Row
  end

  it 'should parse component values' do
    descriptor = @parser.parse(
      <<-BLOCK.unindent
      %row width="100" height="200"
      BLOCK
    )
    descriptor.properties['width'].should == 100
    descriptor.properties['height'].should == 200
  end
end
