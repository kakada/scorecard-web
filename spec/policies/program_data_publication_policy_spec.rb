# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProgramDataPublicationPolicy do
  subject { described_class }

  let(:program) { create(:program) }
  let(:settings_program) { { "data_publishable" => "true" } }

  before do
    allow(Settings).to receive(:program).and_return(settings_program)
  end

  %i[update?].each do |permission|
    permissions permission do
      context "when user is program_admin in the same program and data publishing is enabled" do
        let(:user) { User.new(role: :program_admin, program_id: program.id) }

        it "accepts access" do
          expect(subject).to permit(user, program)
        end
      end

      context "when user is not program_admin" do
        let(:user) { User.new(role: :staff, program_id: program.id) }

        it "denies access" do
          expect(subject).not_to permit(user, program)
        end
      end

      context "when user is program_admin but belongs to a different program" do
        let(:other_program) { create(:program) }
        let(:user) { User.new(role: :program_admin, program_id: other_program.id) }

        it "denies access" do
          expect(subject).not_to permit(user, program)
        end
      end

      context "when data publishing is disabled" do
        let(:user) { User.new(role: :program_admin, program_id: program.id) }
        let(:settings_program) { { "data_publishable" => "false" } }

        it "denies access" do
          expect(subject).not_to permit(user, program)
        end
      end
    end
  end
end
