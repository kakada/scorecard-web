# frozen_string_literal: true

# == Schema Information
#
# Table name: gf_dashboards
#
#  id            :uuid             not null, primary key
#  dashboard_id  :integer
#  dashboard_uid :string
#  dashboard_url :string
#  org_id        :integer
#  org_token     :string
#  program_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class GfDashboard < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid
end
