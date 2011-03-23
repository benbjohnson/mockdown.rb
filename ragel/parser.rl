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

			action store_component_name {
          @component_name = data[@position...p].pack("c*")
			}

			action store_component {
				  level = @indent.length/2
          add_component(name, level)
			}
			
			EOL = ('\n' | '\r\n');
			Indentation = ((' '*) >mark) %store_indent;
			Component_Name = [\-a-zA-Z0-9]+ >mark %store_component_name;
			Component = '%' Component_Name > store_component;
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
      data = data.unpack("c*")
      eof = pe = data.length
 
      %% write init;
      %% write exec;
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
