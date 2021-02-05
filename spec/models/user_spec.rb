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
#  unlock_token           :string
#  locked_at              :datetime
#  failed_attempts        :integer          default(0)
#
require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:program).optional(true) }
  it { is_expected.to belong_to(:local_ngo).optional(true) }
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to define_enum_for(:role).with_values(system_admin: 1, program_admin: 2, staff: 3, lngo: 4) }

  describe "#display_name" do
    let(:user) { build(:user, email: "care.nara@program.org") }

    it { expect(user.display_name).to eq("CARE.NARA") }
  end

  describe "validate presence of program_id" do
    context "is system_admin" do
      before { allow(subject).to receive(:system_admin?).and_return(true)}
      it { is_expected.not_to validate_presence_of(:program_id) }
    end

    context "is not system_admin" do
      before { allow(subject).to receive(:system_admin?).and_return(false) }
      it { is_expected.to validate_presence_of(:program_id) }
    end
  end

  describe "validate presence of local_ngo_id" do
    context "is lngo" do
      before { allow(subject).to receive(:lngo?).and_return(true)}
      it { is_expected.to validate_presence_of(:local_ngo_id) }
    end

    context "is not lngo" do
      before { allow(subject).to receive(:lngo?).and_return(false) }
      it { is_expected.not_to validate_presence_of(:local_ngo_id) }
    end
  end
end
