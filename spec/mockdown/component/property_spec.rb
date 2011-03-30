require File.join(File.dirname(File.expand_path(__FILE__)), '../../spec_helper')

describe Mockdown::Component::Property do
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
    Mockdown::Component::Property.new('foo', 'string').parse('hello').should == 'hello'
  end

  it 'should parse integer to string' do
    Mockdown::Component::Property.new('foo', 'string').parse(10).should == '10'
  end

  it 'should parse decimal to string' do
    Mockdown::Component::Property.new('foo', 'string').parse(100.32).should == '100.32'
  end


  it 'should parse string to integer' do
    Mockdown::Component::Property.new('foo', 'integer').parse('hello').should == 0
  end

  it 'should parse integer to integer' do
    Mockdown::Component::Property.new('foo', 'integer').parse(10).should == 10
  end

  it 'should parse decimal to integer' do
    Mockdown::Component::Property.new('foo', 'integer').parse(100.32).should == 100
  end


  it 'should parse string to decimal' do
    Mockdown::Component::Property.new('foo', 'decimal').parse('hello').should == 0
  end

  it 'should parse integer to decimal' do
    Mockdown::Component::Property.new('foo', 'decimal').parse(10).should == 10
  end

  it 'should parse decimal to decimal' do
    Mockdown::Component::Property.new('foo', 'decimal').parse(100.32).should == 100.32
  end


  #####################################
  # Parse
  #####################################

  it 'should validate string input' do
    Mockdown::Component::Property.new('foo', 'string').valid_input?('hello').should be_true
    Mockdown::Component::Property.new('foo', 'string').valid_input?('10').should be_true
    Mockdown::Component::Property.new('foo', 'string').valid_input?('10.2').should be_true
  end

  it 'should validate integer input' do
    Mockdown::Component::Property.new('foo', 'integer').valid_input?("foo").should be_false
    Mockdown::Component::Property.new('foo', 'integer').valid_input?("10").should be_true
    Mockdown::Component::Property.new('foo', 'integer').valid_input?("10.2").should be_false
  end

  it 'should validate decimal input' do
    Mockdown::Component::Property.new('foo', 'decimal').valid_input?("foo").should be_false
    Mockdown::Component::Property.new('foo', 'decimal').valid_input?("10").should be_true
    Mockdown::Component::Property.new('foo', 'decimal').valid_input?("10.2").should be_true
  end

  it 'should raise error when validating null input' do
    expect {Mockdown::Component::Property.new('foo', 'string').valid_input?(nil)}.
      to raise_error(StandardError, 'Cannot validate null value')
  end
end
