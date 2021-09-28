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
class PdfTemplate < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid

  validates :name, presence: true
  validates :language_code, presence: true
  validates :language_code, uniqueness: { scope: :program_uuid }
end
