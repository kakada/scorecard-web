# frozen_string_literal: true

class Language < ApplicationRecord
  mount_uploader :json_file, JsonFileUploader

  belongs_to :program
end
