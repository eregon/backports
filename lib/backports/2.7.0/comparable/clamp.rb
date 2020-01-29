require 'backports/2.4.0/comparable/clamp' unless Comparable.method_defined? :clamp

if Comparable.instance_method(:clamp).parameters == [[:req], [:req]]
  require 'backports/tools/alias_method_chain'

  module Comparable
    def clamp_with_range(range_or_min, max = nil)
      return clamp_without_range(range_or_min, max) if max
      raise TypeError, "wrong argument type #{range_or_min.class} (expected Range)" unless range_or_min.is_a?(Range)

      if range_or_min.end.nil? # 2.6's endless range
        self < range_or_min.begin ? range_or_min.begin : self
      elsif range_or_min.exclude_end?
        raise ArgumentError, 'cannot clamp with an exclusive range'
      else
        clamp_without_range(range_or_min.begin, range_or_min.end)
      end
    end

    Backports.alias_method_chain self, :clamp, :range
  end
end