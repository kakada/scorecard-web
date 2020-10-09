class Category < ApplicationRecord
  acts_as_nested_set

  validates :name, presence: true
end
