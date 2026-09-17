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
#  locale        :string           default("km"), not null
#
require "rails_helper"

RSpec.describe GfDashboard, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to validate_presence_of(:locale) }
  it { is_expected.to validate_inclusion_of(:locale).in_array(GfDashboard::LOCALES) }

  describe "locale uniqueness" do
    subject { build(:gf_dashboard, program: create(:program)) }

    it { is_expected.to validate_uniqueness_of(:locale).scoped_to(:program_id) }
  end
end
