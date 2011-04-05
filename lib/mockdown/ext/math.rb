module Math
  # Limits a value within a given range.
  #
  # @param [Fixnum] value  the value to limit.
  # @param [Fixnum] min    the minimum allowable value.
  # @param [Fixnum] max    the maximum allowable value.
  #
  # @return                if value is greater than max, then max is returned.
  #                        if value is less than min, then min is returned.
  #                        Otherwise value is returned.
  def self.limit(value, min, max)
    if !min.nil? && value < min
      return min
    elsif !max.nil? && value > max
      return max
    else
      return value
    end
  end
end