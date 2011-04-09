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
			  # TODO: Add check for uneven number of spaces
			  indentation = p-@position
        level = indentation/2
			}

			action begin_component {
        name = data[@position...p].pack("c*")
        descriptor = Mockdown::Component::Descriptor.new(@loader.find(name))
        builder.add(descriptor, level)
			}
			
			action store_property_name {
        property_name = data[@position...p].pack("c*")
        property_name.gsub!('-', '_')
			}

			action store_property_value {
        property_value = data[@position...p].pack("c*")
        property_value = property_value[1..-2]    # Strip quotes
			}
			
			action store_property {
        descriptor.set_property_value(property_name, property_value)
			}
			
			EOL = '\n';
			Indentation = ((' '*) >mark) %store_indent;
			Component_Name = ([a-z] [\-a-z0-9]*) >mark %begin_component %eof(begin_component);
			Property_Name = ([a-z] [\-a-z0-9]*) >mark %store_property_name;
			Property_Value = ('"' (print - '"')* '"') >mark %store_property_value %eof(store_property_value);
			Property = (Property_Name '=' Property_Value) %store_property %eof(store_property);
      Properties = (Property ' '*)*;
			Line = Indentation '%' Component_Name (' '+ Properties EOL | EOL);
      
			main := Line+;
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
        info = get_char_info(data, p)
        raise StandardError.new("Unexpected '#{info[:char]}' at line #{info[:line]}, char #{info[:pos]}")
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
    
    # Determines the line, position and character at a given position in the data.
    def get_char_info(data, p)
      lines = data[0..p].pack('c*').split("\n")
      
      char = data[p].chr
      char = '<space>' if char == ' '
      char = '<newline>' if char == "\n"
      char = '<tab>' if char == "\t"
      
      info = {
        :line => lines.length,
        :pos => lines[-1].length,
        :char => char
      }
      return info
    end
  end
end
