# frozen_string_literal: true

class Array
  def median
    return if self.empty?
    raise "requires all number" if !self.all?(Numeric)

    sorted = self.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def mean
    return if self.empty?

    self.sum / size
  end
end
