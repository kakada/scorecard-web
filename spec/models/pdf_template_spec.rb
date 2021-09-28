# frozen_string_literal: true

# == Schema Information
#
# Table name: pdf_templates
#
#  id            :bigint           not null, primary key
#  name          :string
#  content       :text
#  language_code :string
#  program_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe PdfTemplate, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:language_code) }
  it { is_expected.to validate_uniqueness_of(:language_code).scoped_to(:program_uuid) }
end
