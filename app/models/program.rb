# frozen_string_literal: true

class Program < ApplicationRecord
  has_many :users
  has_many :languages

  validates :name, presence: true

  after_create :create_default_language

  private
    def create_default_language
      languages.create(code: 'km', name: 'Khmer')
    end
end
