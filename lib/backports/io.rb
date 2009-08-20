if RUBY_VERSION < '1.8.7'
  class IO
    make_block_optional :each, :each_line, :each_byte
    class << self
      make_block_optional :foreach
    end
  end

end

class IO
  def bytes
    to_enum :each_byte
  end unless method_defined? :bytes
  
  def chars
    to_enum :each_char
  end unless method_defined? :chars
  
  def each_char
    return to_enum(:each_char) unless block_given?
    if $KCODE == "UTF-8"
      lookup = 7.downto(4)
      while c = read(1) do
        n = c[0]
        leftmost_zero_bit = lookup.find{|i| n[i].zero? }
        case leftmost_zero_bit
        when 7 # ASCII
          yield c
        when 6 # UTF 8 complementary characters
          next # Encoding error, ignore
        else
          more = read(6-leftmost_zero_bit)
          break unless more
          yield c+more
        end
      end
    else
      while s = read(1)
        yield s
      end
    end

    self
  end

  alias_method :getbyte, :getc  unless method_defined? :getbyte
  alias_method :readbyte, :readchar unless method_defined? :readchar
  
  def lines(*args)
    to_enum :each_line, *args
  end unless method_defined? :lines
end
  