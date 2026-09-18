# frozen_string_literal: true

# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null, primary key
#  visit_id   :bigint
#  user_id    :bigint
#  name       :string
#  properties :jsonb
#  time       :datetime
#
class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true

  # Class method
  def self.filter(params)
    events = all
    events = events.where(name: params[:name]) if params[:name].present?
    events = events.where("time >= ?", params[:start_time]) if params[:start_time].present?
    events = events.where("time <= ?", params[:end_time]) if params[:end_time].present?
    events
  end
end
