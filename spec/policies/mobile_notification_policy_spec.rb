# frozen_string_literal: true

require "rails_helper"

RSpec.describe MobileNotificationPolicy, type: :policy do
  subject { described_class }

  let(:settings_program) { { "push_notification" => "true" } }
  let(:notification) { MobileNotification.new }

  before do
    allow(Settings).to receive(:program).and_return(settings_program)
  end

  %i[index? create?].each do |permission|
    permissions permission do
      context "when push_notification is enabled" do
        it "allows system_admin" do
          expect(subject).to permit(User.new(role: :system_admin), notification)
        end

        it "allows program_admin" do
          expect(subject).to permit(User.new(role: :program_admin), notification)
        end

        it "allows staff" do
          expect(subject).to permit(User.new(role: :staff), notification)
        end

        it "denies other roles" do
          expect(subject).not_to permit(User.new(role: :lngo), notification)
        end
      end

      context "when push_notification is disabled" do
        let(:settings_program) { { "push_notification" => "false" } }

        it "denies all roles" do
          expect(subject).not_to permit(User.new(role: :system_admin), notification)
          expect(subject).not_to permit(User.new(role: :program_admin), notification)
          expect(subject).not_to permit(User.new(role: :staff), notification)
          expect(subject).not_to permit(User.new(role: :lngo), notification)
        end
      end
    end
  end

  describe "scope" do
    let!(:program1) { create(:program) }
    let!(:program2) { create(:program) }

    before do
      allow(MobileNotificationWorker).to receive(:perform_async)
    end

    let(:n_p1) do
      MobileNotification.create!(
        title: "t1",
        body: "b1",
        creator: create(:user),
        program_id: program1.id
      )
    end

    let(:n_p2) do
      MobileNotification.create!(
        title: "t2",
        body: "b2",
        creator: create(:user),
        program_id: program2.id
      )
    end

    def resolve_for(user)
      described_class::Scope.new(user, MobileNotification).resolve
    end

    it "returns all for system_admin" do
      user = User.new(role: :system_admin)
      expect(resolve_for(user)).to match_array([n_p1, n_p2])
    end

    it "returns same-program for staff" do
      user = User.new(role: :staff, program_id: program1.id)
      expect(resolve_for(user)).to match_array([n_p1])
    end

    it "returns same-program for program_admin" do
      user = User.new(role: :program_admin, program_id: program2.id)
      expect(resolve_for(user)).to match_array([n_p2])
    end
  end
end
