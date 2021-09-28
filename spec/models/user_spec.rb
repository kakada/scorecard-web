# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
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
#  local_ngo_id           :integer
#  actived                :boolean          default(TRUE)
#  gf_user_id             :integer
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

  describe "validate presence of program_uuid" do
    context "is system_admin" do
      before { allow(subject).to receive(:system_admin?).and_return(true) }
      it { is_expected.not_to validate_presence_of(:program_uuid) }
    end

    context "is not system_admin" do
      before { allow(subject).to receive(:system_admin?).and_return(false) }
      it { is_expected.to validate_presence_of(:program_uuid) }
    end
  end

  describe "validate presence of local_ngo_id" do
    context "is lngo" do
      before { allow(subject).to receive(:lngo?).and_return(true) }
      it { is_expected.to validate_presence_of(:local_ngo_id) }
    end

    context "is not lngo" do
      before { allow(subject).to receive(:lngo?).and_return(false) }
      it { is_expected.not_to validate_presence_of(:local_ngo_id) }
    end
  end

  describe "#regenerate_authentication_token!" do
    let!(:user) { create(:user) }

    context "token is expired" do
      before {
        user.update(authentication_token: "a1b2c3d4", token_expired_date: DateTime.yesterday)
        user.regenerate_authentication_token!
      }

      it { expect(user.reload.authentication_token).not_to eq("a1b2c3d4") }
    end

    context "token is not expired" do
      before {
        user.update(authentication_token: "a1b2c3d4", token_expired_date: DateTime.tomorrow)
        user.regenerate_authentication_token!
      }

      it { expect(user.reload.authentication_token).to eq("a1b2c3d4") }
    end
  end

  describe "#validate, validate_archived_email" do
    let!(:user) { create(:user, email: 'oren@email.com') }
    let(:new_user) { user.dup }

    before {
      user.destroy
      new_user.valid?
    }

    it { expect(new_user.valid?).to be_falsey }

    it "renders error that email is being archived" do
      expect(new_user.errors.first.last).to eq(I18n.t('user.is_being_archived'))
    end
  end
end
