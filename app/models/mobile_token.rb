# frozen_string_literal: true

# == Schema Information
#
# Table name: mobile_tokens
#
#  id         :bigint           not null, primary key
#  token      :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MobileToken < ApplicationRecord
  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid, optional: true

  before_save :set_program_uuid

  validates :token, presence: true

  private
    def set_program_uuid
      return unless program_id.present?

      self.program_uuid ||= Program.find_by(id: program_id).uuid
    end
end
