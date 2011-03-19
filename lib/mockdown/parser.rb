
# line 1 "/projects/benbjohnson/mockdown/ragel/parser.rl"
module Mockdown
  class Parser

    # line 20 "/projects/benbjohnson/mockdown/ragel/parser.rl"


    def initialize()

      # line 12 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
      class << self
        attr_accessor :_parser_actions
        private :_parser_actions, :_parser_actions=
      end
      self._parser_actions = [
      0, 1, 0, 1, 1, 2, 0, 1
      ]

      class << self
        attr_accessor :_parser_key_offsets
        private :_parser_key_offsets, :_parser_key_offsets=
      end
      self._parser_key_offsets = [
      0, 0, 1, 4, 7, 7
      ]

      class << self
        attr_accessor :_parser_trans_keys
        private :_parser_trans_keys, :_parser_trans_keys=
      end
      self._parser_trans_keys = [
      10, 10, 13, 32, 10, 13, 32, 10,
      13, 32, 0
      ]

      class << self
        attr_accessor :_parser_single_lengths
        private :_parser_single_lengths, :_parser_single_lengths=
      end
      self._parser_single_lengths = [
      0, 1, 3, 3, 0, 3
      ]

      class << self
        attr_accessor :_parser_range_lengths
        private :_parser_range_lengths, :_parser_range_lengths=
      end
      self._parser_range_lengths = [
      0, 0, 0, 0, 0, 0
      ]

      class << self
        attr_accessor :_parser_index_offsets
        private :_parser_index_offsets, :_parser_index_offsets=
      end
      self._parser_index_offsets = [
      0, 0, 2, 6, 10, 11
      ]

      class << self
        attr_accessor :_parser_trans_targs
        private :_parser_trans_targs, :_parser_trans_targs=
      end
      self._parser_trans_targs = [
      4, 0, 4, 1, 5, 3, 4, 1,
      0, 3, 0, 4, 1, 5, 3, 0
      ]

      class << self
        attr_accessor :_parser_trans_actions
        private :_parser_trans_actions, :_parser_trans_actions=
      end
      self._parser_trans_actions = [
      0, 0, 5, 5, 1, 5, 0, 0,
      0, 0, 0, 3, 3, 0, 3, 0
      ]

      class << self
        attr_accessor :_parser_eof_actions
        private :_parser_eof_actions, :_parser_eof_actions=
      end
      self._parser_eof_actions = [
      0, 0, 5, 0, 0, 3
      ]

      class << self
        attr_accessor :parser_start
      end
      self.parser_start = 2;
      class << self
        attr_accessor :parser_first_final
      end
      self.parser_first_final = 2;
      class << self
        attr_accessor :parser_error
      end
      self.parser_error = 0;

      class << self
        attr_accessor :parser_en_main
      end
      self.parser_en_main = 2;


      # line 24 "/projects/benbjohnson/mockdown/ragel/parser.rl"
    end

    # Parses the given data into a mockdown structure
    def parse(data)
      data = data.unpack("c*")
      eof = pe = data.length


      # line 116 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
      begin
        p ||= 0
        pe ||= data.length
        cs = parser_start
      end

      # line 32 "/projects/benbjohnson/mockdown/ragel/parser.rl"

      # line 125 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
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
                  # line 6 "/projects/benbjohnson/mockdown/ragel/parser.rl"
                  begin

                    @indent_start = p
                  end
                when 1 then
                  # line 10 "/projects/benbjohnson/mockdown/ragel/parser.rl"
                  begin

                    @indentation = data[@indent_start...p].pack("c*")
                  end
                  # line 217 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
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
                  # line 6 "/projects/benbjohnson/mockdown/ragel/parser.rl"
                  begin

                    @indent_start = p
                  end
                when 1 then
                  # line 10 "/projects/benbjohnson/mockdown/ragel/parser.rl"
                  begin

                    @indentation = data[@indent_start...p].pack("c*")
                  end
                  # line 257 "/projects/benbjohnson/mockdown/lib/mockdown/parser.rb"
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

      # line 33 "/projects/benbjohnson/mockdown/ragel/parser.rl"
    end
  end
end