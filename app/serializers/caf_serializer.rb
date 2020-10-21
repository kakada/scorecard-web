# frozen_string_literal: true

# == Schema Information
#
# Table name: cafs
#
#  id            :bigint           not null, primary key
#  name          :string
#  sex           :string
#  date_of_birth :string
#  tel           :string
#  address       :string
#  local_ngo_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class CafSerializer < ActiveModel::Serializer
  attributes :id, :name, :sex, :date_of_birth, :tel, :address, :local_ngo_id
end
