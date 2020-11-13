# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  color      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  validates :name, presence: true

  has_many :indicators
  has_many :raised_indicators

  before_create :set_color

  private
    def set_color
      self.color = "##{format('%06x', (rand * 0xffffff))}"
    end
end
