# frozen_string_literal: true

# == Schema Information
#
# Table name: local_ngos
#
#  id                  :bigint           not null, primary key
#  name                :string
#  province_id         :string(2)
#  district_id         :string(4)
#  commune_id          :string(6)
#  village_id          :string(8)
#  program_id          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  code                :string
#  target_province_ids :string
#  target_provinces    :string
#  website_url         :string
#
require "rails_helper"

RSpec.describe LocalNgo, type: :model do
  describe "remove!" do
    let!(:lngo) { create(:local_ngo, target_province_ids: "01,02") }
    let!(:scorecard) { create(:scorecard, local_ngo: lngo) }

    context "has scorecards" do
      before {
        lngo.remove!
      }

      it "doesn't do anything" do
        expect(LocalNgo.find_by(id: lngo.id)).not_to be_nil
      end
    end

    context "has only soft delete scorecards" do
      before {
        scorecard.destroy
        lngo.remove!
      }

      it "hides from finding" do
        expect(LocalNgo.find_by(id: lngo.id)).to be_nil
      end

      it "apply soft delete" do
        expect(LocalNgo.with_deleted.find_by(id: lngo.id)).not_to be_nil
      end
    end

    context "no scorecards" do
      before {
        scorecard.really_destroy!
        lngo.remove!
      }

      it "really delete" do
        expect(LocalNgo.with_deleted.find_by(id: lngo.id)).to be_nil
      end
    end
  end
end
