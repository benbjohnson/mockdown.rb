require File.join(File.dirname(File.expand_path(__FILE__)), '../../spec_helper')

describe Mockdown::Component::Property do
  ##############################################################################
  # Setup
  ##############################################################################

  before do
    @component = Mockdown::Component.new()
    @string_property = Mockdown::Component::Property.new('foo', 'string')
    @integer_property = Mockdown::Component::Property.new('foo', 'integer')
    @decimal_property = Mockdown::Component::Property.new('foo', 'decimal')
    @length_property = Mockdown::Component::Property.new('foo', 'length')
    @color_property = Mockdown::Component::Property.new('foo', 'color')
  end


  ##############################################################################
  # Tests
  ##############################################################################

  #####################################
  # Validation
  #####################################

  it 'should validate string type' do
    Mockdown::Component::Property.valid_type?('string').should be_true
  end

  it 'should validate integer type' do
    Mockdown::Component::Property.valid_type?('integer').should be_true
  end

  it 'should validate decimal type' do
    Mockdown::Component::Property.valid_type?('decimal').should be_true
  end

  it 'should not validate invalid property type' do
    Mockdown::Component::Property.valid_type?('foo').should be_false
  end

  #####################################
  # Constructor
  #####################################

  it 'should throw error for invalid type' do
    expect {Mockdown::Component::Property.new('foo', 'bar')}.
      to raise_error(StandardError, 'Invalid data type for \'foo\' property: bar')
  end



  #####################################
  # Parse
  #####################################

  it 'should parse string to string' do
    @string_property.set_value(@component, 'hello')
    @component.get_raw_property_value('foo').should == 'hello'
  end

  it 'should parse integer to string' do
    @string_property.set_value(@component, '10')
    @component.get_raw_property_value('foo').should == '10'
  end

  it 'should parse decimal to string' do
    @string_property.set_value(@component, '100.32')
    @component.get_raw_property_value('foo').should == '100.32'
  end


  it 'should parse string to integer' do
    @integer_property.set_value(@component, 'hello')
    @component.get_raw_property_value('foo').should == 0
  end

  it 'should parse integer to integer' do
    @integer_property.set_value(@component, 10)
    @component.get_raw_property_value('foo').should == 10
  end

  it 'should parse decimal to integer' do
    @integer_property.set_value(@component, 100.32)
    @component.get_raw_property_value('foo').should == 100
  end


  it 'should parse string to decimal' do
    @decimal_property.set_value(@component, 'hello')
    @component.get_raw_property_value('foo').should == 0
  end

  it 'should parse integer to decimal' do
    @decimal_property.set_value(@component, 10)
    @component.get_raw_property_value('foo').should == 10
  end

  it 'should parse decimal to decimal' do
    @decimal_property.set_value(@component, 100.32)
    @component.get_raw_property_value('foo').should == 100.32
  end

  it 'should parse string to string' do
    @string_property.set_value(@component, 'hello')
    @component.get_raw_property_value('foo').should == 'hello'
  end

  it 'should parse integer to string' do
    @string_property.set_value(@component, '10')
    @component.get_raw_property_value('foo').should == '10'
  end


  it 'should parse length' do
    @length_property.set_value(@component, '10px')
    @component.get_raw_property_value('foo').should == 10
  end

  it 'should parse integer to length' do
    @length_property.set_value(@component, 10)
    @component.get_raw_property_value('foo').should == 10
  end


  it 'should parse color' do
    @color_property.set_value(@component, '#FF00FF')
    @component.get_raw_property_value('foo').should == 16_711_935
  end


  #####################################
  # Validation
  #####################################

  it 'should validate string input' do
    @string_property.valid_input?(@component, 'hello').should be_true
    @string_property.valid_input?(@component, '10').should be_true
    @string_property.valid_input?(@component, '10.2').should be_true
  end

  it 'should validate integer input' do
    @integer_property.valid_input?(@component, "foo").should be_false
    @integer_property.valid_input?(@component, "10").should be_true
    @integer_property.valid_input?(@component, "10.2").should be_false
  end

  it 'should validate decimal input' do
    @decimal_property.valid_input?(@component, "foo").should be_false
    @decimal_property.valid_input?(@component, "10").should be_true
    @decimal_property.valid_input?(@component, "10.2").should be_true
  end

  it 'should validate length input' do
    @length_property.valid_input?(@component, "10px").should be_true
    @length_property.valid_input?(@component, "10").should be_true
    @length_property.valid_input?(@component, "10.2").should be_false
    @length_property.valid_input?(@component, "hello").should be_false
  end

  it 'should validate color input' do
    @color_property.valid_input?(@component, '#FF00FF').should be_true
    @color_property.valid_input?(@component, "10").should be_false
    @color_property.valid_input?(@component, "10.2").should be_false
    @color_property.valid_input?(@component, "hello").should be_false
  end

  it 'should raise error when validating null input' do
    expect {@string_property.valid_input?(@component, nil)}.
      to raise_error(StandardError, 'Cannot validate null value')
  end
end
