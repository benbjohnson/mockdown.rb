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

  it 'should parse property values' do
    descriptor = @parser.parse(
      <<-BLOCK.unindent
      %row width="100" height="200"
      BLOCK
    )
    descriptor.get_property_value('width').should == 100
    descriptor.get_property_value('height').should == 200
  end

  it 'should error on invalid property values' do
    expect do
      @parser.parse(
        <<-BLOCK.unindent
        %row width="foo"
        BLOCK
      )
    end.
      to raise_error(StandardError, "Invalid integer value for 'width': 'foo'")
  end

  it 'should parse a multiline component' do
    descriptor = @parser.parse(
      <<-BLOCK.unindent
      %row
        %col
        %col
      BLOCK
    )
    descriptor.parent.should == Mockdown::Component::Row
    descriptor.children.length.should == 2
  end
end
