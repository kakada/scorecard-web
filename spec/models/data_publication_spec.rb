# == Schema Information
#
# Table name: data_publications
#
#  id               :uuid             not null, primary key
#  program_id       :integer
#  published_option :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe DataPublication, type: :model do
  it { is_expected.to belong_to(:program) }

  describe "#after_create, create_data_publication_log" do
    let!(:program) { create(:program) }

    it "creates data_publication_log" do
      expect {
        create(:data_publication, published_option: :publish_all, program: program)
      }.to change {
        program.data_publication_logs.count
      }.by 1
    end
  end

  describe "#after_save, create_data_publication_log" do
    let!(:program) { create(:program) }
    let!(:data_publication) { create(:data_publication, published_option: :publish_all, program: program) }

    it "creates data_publication_log" do
      expect {
        data_publication.update(published_option: :publish_from_today)
      }.to change {
        program.data_publication_logs.count
      }.by 1
    end
  end

  describe "#after_save, update scorecards" do
    let!(:program)    { create(:program) }
    let!(:scorecard1) { create(:scorecard, program: program, published: false, created_at: Date.yesterday) }
    let!(:scorecard2) { create(:scorecard, program: program, published: false, created_at: Date.today) }

    context "publish_all" do
      before {
        create(:data_publication, published_option: :publish_all, program: program)
      }

      it { expect(scorecard1.reload.published).to be_truthy }
      it { expect(scorecard2.reload.published).to be_truthy }
    end
  end
end
