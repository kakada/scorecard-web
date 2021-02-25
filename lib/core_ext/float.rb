# frozen_string_literal: true

class Float
  def round_up_half
    adjustNum = (self % 0.5 > 0) && (self % 0.5 <= 0.24) ? (self + 0.5) : self
    (adjustNum * 2).round / 2.0
  end
end
