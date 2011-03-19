require File.join(File.dirname(File.expand_path(__FILE__)), 'spec_helper')

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

  it 'should create a component' do
    
  end
end
