require 'mockdown/parser/builder'

module Mockdown
  class Parser
    %%{
      machine parser;

			# Marks the starting position
			action mark {
			  @position = p
			}

			action store_indent {
        @last_indent = @indent
        @indent = data[@position...p].pack("c*")
			}

			action begin_component {
        name = data[@position...p].pack("c*")
        @descriptor = @loader.find(name)
			}
			
			action store_component {
        level = @indent.length/2
        builder.add(@descriptor, level)
			}

			action store_component_property_key {
        component_key = data[@position...p].pack("c*")
			}

			action store_component_property_value {
        component_value = data[@position...p].pack("c*")
        component_value = component_value[1..-2]    # Strip quotes
			}
			
			action store_component_property {
        component_value = data[@position...p].pack("c*")
        component_value = component_value[1..-2]    # Strip quotes
			}
			
			EOL = ('\n' | '\r\n');
			Indentation = ((' '*) >mark) %store_indent;
			Component_Name = [\-a-zA-Z0-9]+ >mark %begin_component;
			Component_Property_Key = [\-a-zA-Z0-9]+ >mark %store_component_property_key;
			Component_Property_Value = '"' [^"]+ . '"' >mark %store_component_property_value;
			Component_Property = Component_Property_Key '=' Component_Property_Value %store_component_property;
			Component_Properties = Component_Property . (' '+ | EOL);
			Component = '%' Component_Name (' '+ . Component_Properties)? %store_component;
			Code = Component;
			Line = Indentation Code? :> EOL?;

			main := Line;
    }%%
    
    def initialize()
      @loader = Loader.new()
      %% write data;
    end

    # Parses the given data into a mockdown structure
    def parse(data)
      builder = Mockdown::Parser::Builder.new()
      data = data.unpack("c*")
      eof = pe = data.length

      %% write init;
      %% write exec;

      return builder.descriptor
    end


    ############################################################################
    protected
    ############################################################################

    # Adds a component to the current descriptor
    def add_component(name, level)
      descriptor = @loader.find(name)
    end
  end
end
