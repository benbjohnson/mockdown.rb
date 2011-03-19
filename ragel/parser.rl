module Mockdown
  class Parser
    %%{
      machine parser;

			# Marks the starting position
			action mark {
          @position = p
			}

			action store_indent {
          @indentation = data[@position...p].pack("c*")
			}

			action store_component_name {
          @component_name = data[@position...p].pack("c*")
			}
			
			EOL = ('\n' | '\r\n');
			Indentation = ((' '*) >mark) %store_indent;
			Component_Name = [\-a-zA-Z0-9]+ >mark %store_component_name;
			Component = '%' Component_Name;
			Code = Component;
			Line = Indentation Code? :> EOL?;

			main := Line;
    }%%
    
    def initialize()
      %% write data;
    end

    # Parses the given data into a mockdown structure
    def parse(data)
      data = data.unpack("c*")
      eof = pe = data.length
 
      %% write init;
      %% write exec;
    end
  end
end