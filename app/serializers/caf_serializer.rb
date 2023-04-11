# frozen_string_literal: true

# == Schema Information
#
# Table name: cafs
#
#  id                        :bigint           not null, primary key
#  name                      :string
#  sex                       :string
#  date_of_birth             :string
#  tel                       :string
#  address                   :string
#  local_ngo_id              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  actived                   :boolean          default(TRUE)
#  educational_background_id :string
#  scorecard_knowledge_id    :string
#  deleted_at                :datetime
#  province_id               :string
#  district_id               :string
#  commune_id                :string
#
class CafSerializer < ActiveModel::Serializer
  attributes :id, :name, :sex, :date_of_birth, :tel, :address, :local_ngo_id,
             :educational_background

  has_many :scorecard_knowledges

  def educational_background
    object.educational_background_name
  end
end
