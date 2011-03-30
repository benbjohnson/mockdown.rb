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

			action store_property_name {
        property_name = data[@position...p].pack("c*")
			}

			action store_property_value {
        property_value = data[@position...p].pack("c*")
        property_value = property_value[1..-2]    # Strip quotes
			}
			
			action store_property {
        @descriptor.set_property_value(property_name, property_value)
			}
			
			EOL = '\n';
			Indentation = ((' '*) >mark) %store_indent;
			Component_Name = ([\a-z] [\-a-z0-9]*) >mark %begin_component;
			Property_Name = ([\a-z] [\-a-z0-9]+) >mark %store_property_name;
			Property_Value = ('"' . [^"]+ . '"') >mark %store_property_value;
			Property = (Property_Name . '=' . Property_Value) %store_property;
			Component = ('%' Component_Name . (' '+ . Property)* . ' '*) %store_component;
			Line = Indentation Component? :> EOL?;

			main := Line;
    }%%
    
    def initialize()
      @loader = Loader.new()
      %% write data;
    end

    # Parses the given data into a mockdown structure
    def parse(data)
      builder = Mockdown::Parser::Builder.new()
      
      # Convert Windows newlines to Unix newlines for FSM simplicity.
      data.gsub!("\r\n", "\n")
      
      # Prepare data for Ragel
      data = data.unpack("c*")
      eof = pe = data.length

      %% write init;
      %% write exec;

      # Raise error if parser does not complete
      if p != pe
        raise StandardError.new("Unexpected character at character #{p}: '#{data[p].chr}'")
      end
      
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
