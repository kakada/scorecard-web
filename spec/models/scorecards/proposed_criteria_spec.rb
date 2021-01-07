require "rails_helper"

RSpec.describe Scorecards::ProposedCriteria, type: :model do
  describe '#criterias' do
    let!(:scorecard) { create(:scorecard) }

    let!(:female1)   { create(:participant, gender: 'female', poor_card: true, youth: true) }
    let!(:female2)   { create(:participant, gender: 'female', disability: true, minority: true) }
    let!(:male)      { create(:participant, gender: 'male', youth: true) }
    let!(:other)     { create(:participant, gender: 'other', minority: true, youth: true) }

    let!(:indicator1) { create(:indicator) }
    let!(:indicator2) { create(:indicator) }
    let!(:indicator3) { create(:indicator) }

    let(:criterias) { Scorecards::ProposedCriteria.new(scorecard.uuid).criterias }
    let(:criteria1) { criterias.select{ |c| c['id'] == indicator1.id }[0] }
    let(:criteria2) { criterias.select{ |c| c['id'] == indicator2.id }[0] }
    let(:criteria3) { criterias.select{ |c| c['id'] == indicator3.id }[0] }

    before do
      create(:raised_indicator, scorecard: scorecard, indicatorable: indicator1, participant_uuid: female1.uuid)
      create(:raised_indicator, scorecard: scorecard, indicatorable: indicator2, participant_uuid: female1.uuid)

      create(:raised_indicator, scorecard: scorecard, indicatorable: indicator1, participant_uuid: female2.uuid)
      create(:raised_indicator, scorecard: scorecard, indicatorable: indicator3, participant_uuid: female2.uuid)

      create(:raised_indicator, scorecard: scorecard, indicatorable: indicator3, participant_uuid: male.uuid)
      create(:raised_indicator, scorecard: scorecard, indicatorable: indicator3, participant_uuid: other.uuid)
    end

    it 'returns criterias length with 3' do
      expect(criterias.length).to eq(3)
    end

    describe 'criteria1' do
      it { expect(criteria1['count']).to eq(2) }
      it { expect(criteria1['name']).to eq(indicator1.name) }
      it { expect(criteria1['female_count']).to eq(2) }
      it { expect(criteria1['minority_count']).to eq(1) }
      it { expect(criteria1['disability_count']).to eq(1) }
      it { expect(criteria1['poor_card_count']).to eq(1) }
      it { expect(criteria1['youth_count']).to eq(1) }
    end

    describe 'criteria2' do
      it { expect(criteria2['count']).to eq(1) }
      it { expect(criteria2['name']).to eq(indicator2.name) }
      it { expect(criteria2['female_count']).to eq(1) }
      it { expect(criteria2['minority_count']).to eq(0) }
      it { expect(criteria2['disability_count']).to eq(0) }
      it { expect(criteria2['poor_card_count']).to eq(1) }
      it { expect(criteria2['youth_count']).to eq(1) }
    end

    describe 'criteria3' do
      it { expect(criteria3['count']).to eq(3) }
      it { expect(criteria3['name']).to eq(indicator3.name) }
      it { expect(criteria3['female_count']).to eq(1) }
      it { expect(criteria3['minority_count']).to eq(2) }
      it { expect(criteria3['disability_count']).to eq(1) }
      it { expect(criteria3['poor_card_count']).to eq(0) }
      it { expect(criteria3['youth_count']).to eq(2) }
    end
  end
end
