# frozen_string_literal: true

# == Schema Information
#
# Table name: data_publication_logs
#
#  id               :uuid             not null, primary key
#  program_id       :integer
#  published_option :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "rails_helper"

RSpec.describe DataPublicationLog, type: :model do
  it { is_expected.to belong_to(:program) }
end
