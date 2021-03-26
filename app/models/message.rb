# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :program
  has_many :notifications

  def display_content
    # interpret the content
    content
  end
end
