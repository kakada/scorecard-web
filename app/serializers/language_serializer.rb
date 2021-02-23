# frozen_string_literal: true

# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  code       :string
#  name_en    :string
#  json_file  :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name_km    :string
#
class LanguageSerializer < ActiveModel::Serializer
  attributes :id, :code, :name_en, :name_km
end
