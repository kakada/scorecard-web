# frozen_string_literal: true

# == Schema Information
#
# Table name: templates
#
#  id         :bigint           not null, primary key
#  name       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Template < ApplicationRecord
  include Categorizable

  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid

  validates :name, presence: true, uniqueness: { scope: :program_id }
end
