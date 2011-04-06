require File.join(File.dirname(File.expand_path(__FILE__)), '../../spec_helper')

describe Mockdown::Component::Property do
  ##############################################################################
  # Tests
  ##############################################################################

  #####################################
  # Parse
  #####################################

  it 'should parse multiple properties' do
    component = Mockdown::Component.new()
    component.add_property(Mockdown::Component::Property.new('border_thickness', 'length'))
    component.add_property(Mockdown::Component::Property.new('border_color', 'color'))
    component.add_property(Mockdown::Component::Property.new('border_alpha', 'percent'))
    property = Mockdown::Component::CompositeProperty.new('border', 'border_thickness border_color border_alpha')
    property.parse(component, '1px #ff0000 50%')
    component.border_thickness.should == '1px'
    component.border_color.should == '#ff0000'
    component.border_alpha.should == '50%'
  end
end
