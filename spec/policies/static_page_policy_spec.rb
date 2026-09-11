# frozen_string_literal: true

require "rails_helper"

RSpec.describe StaticPagePolicy, type: :policy do
  subject { described_class }

  let(:static_page) { build(:static_page) }

  %i[index? show? new? create? edit? update? destroy?].each do |permission|
    permissions permission do
      it "allows system_admin" do
        expect(subject).to permit(User.new(role: :system_admin), static_page)
      end

      it "denies program_admin" do
        expect(subject).not_to permit(User.new(role: :program_admin), static_page)
      end

      it "denies staff" do
        expect(subject).not_to permit(User.new(role: :staff), static_page)
      end

      it "denies lngo" do
        expect(subject).not_to permit(User.new(role: :lngo), static_page)
      end
    end
  end
end
