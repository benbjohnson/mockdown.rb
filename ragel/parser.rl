module Mockdown
  class Parser
    %%{
      machine parser;

			action begin_indent {
          @indent_start = p
			}

			action store_indent {
          @indentation = data[@indent_start...p].pack("c*")
			}
			
			EOL = ('\n' | '\r\n');
			Indentation = ((' '*) >begin_indent) %store_indent;
			Code = (any-Indentation)*;
			Line = Indentation . Code :> EOL?;

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