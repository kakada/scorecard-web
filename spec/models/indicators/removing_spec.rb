# frozen_string_literal: true

# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tag_id             :integer
#  display_order      :integer
#  image              :string
#  uuid               :string
#  audio              :string
#  type               :string           default("Indicators::PredefineIndicator")
#  deleted_at         :datetime
#
require "rails_helper"

RSpec.describe Indicator, type: :model do
  describe "#removing" do
    context "has raised indicator" do
      let!(:raised_indicator) { create(:raised_indicator) }
      let(:indicator) { raised_indicator.indicator }

      it "doesn't do anything" do
        indicator.remove!

        expect(Indicator.find_by id: indicator.id).not_to be_nil
      end
    end

    context "has no any raised indicator" do
      let(:indicator) { create(:indicator) }

      it "apply soft delete" do
        indicator.remove!

        expect(Indicator.only_deleted.find_by id: indicator.id).not_to be_nil
      end
    end
  end
end
