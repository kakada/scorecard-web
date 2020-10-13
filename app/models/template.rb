class Template < ApplicationRecord
  include Categorizable

  validates :name, presence: true
end
