
# line 1 "/projects/benbjohnson/mockdown/ragel/parser.rl"
require 'mockdown/parser/builder'

module Mockdown
  class Parser
    
# line 118 "/projects/benbjohnson/mockdown/ragel/parser.rl"

    
    def initialize()
      @loader = Loader.new()
      
# line 15 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
class << self
	attr_accessor :_parser_actions
	private :_parser_actions, :_parser_actions=
end
self._parser_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 2, 0, 1, 2, 2, 
	3, 2, 5, 6, 3, 5, 6, 3
]

class << self
	attr_accessor :_parser_key_offsets
	private :_parser_key_offsets, :_parser_key_offsets=
end
self._parser_key_offsets = [
	0, 0, 2, 7, 13, 14, 15, 16, 
	19, 19, 22, 29, 33, 35
]

class << self
	attr_accessor :_parser_trans_keys
	private :_parser_trans_keys, :_parser_trans_keys=
end
self._parser_trans_keys = [
	7, 122, 45, 48, 57, 97, 122, 45, 
	61, 48, 57, 97, 122, 34, 34, 34, 
	10, 32, 37, 10, 32, 37, 10, 32, 
	45, 48, 57, 97, 122, 10, 32, 7, 
	122, 10, 32, 10, 32, 45, 7, 47, 
	48, 57, 58, 96, 97, 122, 0
]

class << self
	attr_accessor :_parser_single_lengths
	private :_parser_single_lengths, :_parser_single_lengths=
end
self._parser_single_lengths = [
	0, 0, 1, 2, 1, 1, 1, 3, 
	0, 3, 3, 2, 2, 3
]

class << self
	attr_accessor :_parser_range_lengths
	private :_parser_range_lengths, :_parser_range_lengths=
end
self._parser_range_lengths = [
	0, 1, 2, 2, 0, 0, 0, 0, 
	0, 0, 2, 1, 0, 4
]

class << self
	attr_accessor :_parser_index_offsets
	private :_parser_index_offsets, :_parser_index_offsets=
end
self._parser_index_offsets = [
	0, 0, 2, 6, 11, 13, 15, 17, 
	21, 22, 26, 32, 36, 39
]

class << self
	attr_accessor :_parser_indicies
	private :_parser_indicies, :_parser_indicies=
end
self._parser_indicies = [
	0, 1, 2, 2, 2, 1, 2, 3, 
	2, 2, 1, 4, 1, 1, 5, 6, 
	5, 7, 8, 9, 1, 1, 10, 11, 
	12, 1, 13, 14, 15, 15, 15, 1, 
	17, 18, 16, 1, 19, 20, 1, 17, 
	18, 21, 16, 21, 16, 21, 1, 0
]

class << self
	attr_accessor :_parser_trans_targs
	private :_parser_trans_targs, :_parser_trans_targs=
end
self._parser_trans_targs = [
	10, 0, 3, 4, 5, 6, 12, 8, 
	9, 1, 8, 9, 1, 8, 11, 10, 
	2, 8, 13, 8, 11, 3
]

class << self
	attr_accessor :_parser_trans_actions
	private :_parser_trans_actions, :_parser_trans_actions=
end
self._parser_trans_actions = [
	1, 0, 0, 9, 1, 0, 0, 11, 
	1, 11, 3, 0, 3, 14, 5, 0, 
	1, 7, 1, 20, 17, 1
]

class << self
	attr_accessor :_parser_eof_actions
	private :_parser_eof_actions, :_parser_eof_actions=
end
self._parser_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 11, 
	0, 3, 14, 7, 20, 7
]

class << self
	attr_accessor :parser_start
end
self.parser_start = 7;
class << self
	attr_accessor :parser_first_final
end
self.parser_first_final = 7;
class << self
	attr_accessor :parser_error
end
self.parser_error = 0;

class << self
	attr_accessor :parser_en_main
end
self.parser_en_main = 7;


# line 123 "/projects/benbjohnson/mockdown/ragel/parser.rl"
    end

    # Parses the given data into a mockdown structure
    def parse(data)
      builder = Mockdown::Parser::Builder.new()
      
      # Convert Windows newlines to Unix newlines for FSM simplicity.
      data.gsub!("\r\n", "\n")
      
      # Prepare data for Ragel
      data = data.unpack("c*")
      eof = pe = data.length

      
# line 151 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = parser_start
end

# line 137 "/projects/benbjohnson/mockdown/ragel/parser.rl"
      
# line 160 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = _parser_key_offsets[cs]
	_trans = _parser_index_offsets[cs]
	_klen = _parser_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p] < _parser_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p] > _parser_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _parser_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p] < _parser_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p] > _parser_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	_trans = _parser_indicies[_trans]
	cs = _parser_trans_targs[_trans]
	if _parser_trans_actions[_trans] != 0
		_acts = _parser_trans_actions[_trans]
		_nacts = _parser_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _parser_actions[_acts - 1]
when 0 then
# line 9 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

			  @position = p
					end
when 1 then
# line 13 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        @last_indent = @indent
        @indent = data[@position...p].pack("c*")
					end
when 2 then
# line 18 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        name = data[@position...p].pack("c*")
        @descriptor = @loader.find(name)
					end
when 3 then
# line 23 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        level = @indent.length/2
        builder.add(@descriptor, level)
					end
when 4 then
# line 95 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        property_name = data[@position...p].pack("c*")
					end
when 5 then
# line 99 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        property_value = data[@position...p].pack("c*")
        property_value = property_value[1..-2]    # Strip quotes
					end
when 6 then
# line 104 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        @descriptor.set_property_value(property_name, property_value)
					end
# line 287 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	__acts = _parser_eof_actions[cs]
	__nacts =  _parser_actions[__acts]
	__acts += 1
	while __nacts > 0
		__nacts -= 1
		__acts += 1
		case _parser_actions[__acts - 1]
when 0 then
# line 9 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

			  @position = p
					end
when 1 then
# line 13 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        @last_indent = @indent
        @indent = data[@position...p].pack("c*")
					end
when 2 then
# line 18 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        name = data[@position...p].pack("c*")
        @descriptor = @loader.find(name)
					end
when 3 then
# line 23 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        level = @indent.length/2
        builder.add(@descriptor, level)
					end
when 5 then
# line 99 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        property_value = data[@position...p].pack("c*")
        property_value = property_value[1..-2]    # Strip quotes
					end
when 6 then
# line 104 "/projects/benbjohnson/mockdown/ragel/parser.rl"
		begin

        @descriptor.set_property_value(property_name, property_value)
					end
# line 355 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
		end # eof action switch
	end
	if _trigger_goto
		next
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 138 "/projects/benbjohnson/mockdown/ragel/parser.rl"

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
