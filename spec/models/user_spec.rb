# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#  program_id             :integer
#  authentication_token   :string           default("")
#  token_expired_date     :datetime
#  language_code          :string           default("en")
#
require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:program).optional(true) }
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to define_enum_for(:role).with_values(system_admin: 1, program_admin: 2, staff: 3, guest: 4) }
end
