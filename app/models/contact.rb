# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id           :bigint           not null, primary key
#  contact_type :integer
#  value        :string
#  program_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Contact < ApplicationRecord
  enum contact_type: {
    tel: 1,
    email: 2
  }

  CONTACT_TYPES = contact_types.keys.map { |key| [I18n.t("contact.#{key}"), key] }

  belongs_to :program, foreign_key: :program_uuid, primary_key: :uuid, optional: true

  scope :no_program, -> { where(program: nil) }

  validates :contact_type, presence: true
  validates :value, presence: true
  validates :value, email: true, if: :email?, allow_blank: true
  validates :value, tel: true, if: :tel?, allow_blank: true
end
