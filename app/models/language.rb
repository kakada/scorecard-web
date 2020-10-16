# frozen_string_literal: true

# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  json_file  :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Language < ApplicationRecord
  mount_uploader :json_file, JsonFileUploader

  belongs_to :program

  validates :code, presence: true
  validates :name, presence: true
end
