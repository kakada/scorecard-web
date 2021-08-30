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
#  educational_background_id :string
#  scorecard_knowledge_id    :string
#
class Caf < ApplicationRecord
  belongs_to :local_ngo
  has_many :scorecards_caf
  has_many :scorecards, through: :scorecards_caf
  belongs_to :educational_background, optional: true
  belongs_to :scorecard_knowledge, optional: true

  delegate :name, to: :educational_background, prefix: :educational_background, allow_nil: true
  delegate :name, to: :scorecard_knowledge, prefix: :scorecard_knowledge, allow_nil: true

  GENDERS = %w(female male other)

  validates :name, presence: true
  validates :sex, inclusion: { in: GENDERS }, allow_blank: true

  scope :actives, -> { where(actived: true) }

  def self.filter(params)
    scope = all
    scope = scope.where("LOWER(name) LIKE ? OR tel LIKE ?", "%#{params[:keyword].downcase}%", "%#{params[:keyword].downcase}%") if params[:keyword].present?
    scope = scope.where(local_ngo_id: params[:local_ngo_id]) if params[:local_ngo_id].present?
    scope
  end
end
