# frozen_string_literal: true

class Language < ApplicationRecord
  mount_uploader :json_file, JsonFileUploader

  belongs_to :program

  validates :code, presence: true
  validates :name, presence: true
end
