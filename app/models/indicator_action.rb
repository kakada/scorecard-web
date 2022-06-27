# frozen_string_literal: true

# == Schema Information
#
# Table name: indicator_actions
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  predefined     :boolean          default(TRUE)
#  kind           :integer
#  indicator_uuid :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class IndicatorAction < ApplicationRecord
  include IndicatorActions::Removing

  belongs_to :indicator, foreign_key: :indicator_uuid, primary_key: :uuid, optional: true
  has_many :proposed_indicator_actions, dependent: :destroy
  has_many :voting_indicators, through: :proposed_indicator_actions

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { scope: :indicator_uuid }, if: :predefined
  validates :kind, presence: true

  enum kind: {
    weakness: 1,
    strength: 2,
    suggested_action: 3,
  }

  scope :predefineds, -> { where(predefined: true) }
  scope :customs, -> { where(predefined: false) }

  def self.filter(params)
    scope = all
    scope = scope.where("name LIKE ? OR code LIKE ?", "%#{params[:name]}%", "%#{params[:name]}%") if params[:name].present?
    scope = scope.where(kind: params[:kind]) if params[:kind].present?
    scope = scope.where(indicator_uuid: params[:indicator_uuid]) if params[:indicator_uuid].present?
    scope
  end
end
