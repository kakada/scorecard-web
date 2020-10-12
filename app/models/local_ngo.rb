class LocalNgo < ApplicationRecord
  belongs_to :program
  has_many :cafs
end
