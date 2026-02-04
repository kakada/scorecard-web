# frozen_string_literal: true

# == Schema Information
#
# Table name: participants
#
#  uuid           :string           not null, primary key
#  scorecard_uuid :string
#  age            :integer
#  gender         :string
#  disability     :boolean          default(FALSE)
#  minority       :boolean          default(FALSE)
#  poor_card      :boolean          default(FALSE)
#  youth          :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  countable      :boolean          default(TRUE)
#
require "rails_helper"

RSpec.describe Participant, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:scorecard).optional }
  end

  describe "gender helpers" do
    it "returns true for female? when gender is female" do
      participant = build(:participant, gender: Participant::GENDER_FEMALE)
      expect(participant.female?).to be(true)
      expect(participant.male?).to be(false)
    end

    it "returns true for male? when gender is male" do
      participant = build(:participant, gender: Participant::GENDER_MALE)
      expect(participant.male?).to be(true)
      expect(participant.female?).to be(false)
    end
  end

  describe "scopes" do
    it "filters by genders" do
      female = create(:participant, gender: Participant::GENDER_FEMALE)
      male   = create(:participant, gender: Participant::GENDER_MALE)
      other  = create(:participant, gender: Participant::GENDER_OTHER)

      expect(Participant.females).to include(female)
      expect(Participant.males).to include(male)
      expect(Participant.others).to include(other)
    end
  end

  describe "counter increments on create" do
    it "increments scorecard counters when a countable participant is created" do
      scorecard = create(:scorecard,
        number_of_participant: 0,
        number_of_female: 0,
        number_of_youth: 0,
        number_of_disability: 0,
        number_of_ethnic_minority: 0,
        number_of_id_poor: 0
      )

      create(:participant,
        scorecard: scorecard,
        gender: Participant::GENDER_FEMALE,
        youth: true,
        disability: true,
        minority: true,
        poor_card: true,
        countable: true
      )

      sc = scorecard.reload
      expect(sc.number_of_participant).to eq(1)
      expect(sc.number_of_female).to eq(1)
      expect(sc.number_of_youth).to eq(1)
      expect(sc.number_of_disability).to eq(1)
      expect(sc.number_of_ethnic_minority).to eq(1)
      expect(sc.number_of_id_poor).to eq(1)
    end

    it "does not increment counters when participant is not countable" do
      scorecard = create(:scorecard,
        number_of_participant: 0,
        number_of_female: 0
      )

      create(:participant,
        scorecard: scorecard,
        gender: Participant::GENDER_FEMALE,
        countable: false
      )

      sc = scorecard.reload
      expect(sc.number_of_participant.to_i).to eq(0)
      expect(sc.number_of_female.to_i).to eq(0)
    end
  end

  describe "nested attributes with scorecard" do
    it "increments counters when participants are created via nested attributes" do
      scorecard = create(:scorecard,
        number_of_participant: 0,
        number_of_female: 0,
        number_of_youth: 0,
        number_of_disability: 0,
        number_of_ethnic_minority: 0,
        number_of_id_poor: 0
      )

      scorecard.update!(
        participants_attributes: [
          {
            gender: Participant::GENDER_FEMALE,
            youth: true,
            disability: false,
            minority: true,
            poor_card: false,
            countable: true
          },
          {
            gender: Participant::GENDER_MALE,
            youth: false,
            disability: true,
            minority: false,
            poor_card: true,
            countable: true
          }
        ]
      )

      sc = scorecard.reload
      expect(sc.number_of_participant).to eq(2)
      expect(sc.number_of_female).to eq(1)
      expect(sc.number_of_youth).to eq(1)
      expect(sc.number_of_disability).to eq(1)
      expect(sc.number_of_ethnic_minority).to eq(1)
      expect(sc.number_of_id_poor).to eq(1)
    end
  end

  describe "counter decrements on destroy" do
    it "decrements scorecard counters when a countable participant is destroyed" do
      scorecard = create(:scorecard,
        number_of_participant: 0,
        number_of_female: 0,
        number_of_youth: 0,
        number_of_disability: 0,
        number_of_ethnic_minority: 0,
        number_of_id_poor: 0
      )

      participant = create(:participant,
        scorecard: scorecard,
        gender: Participant::GENDER_FEMALE,
        youth: true,
        disability: true,
        minority: true,
        poor_card: true,
        countable: true
      )

      sc = scorecard.reload
      expect(sc.number_of_participant).to eq(1)
      expect(sc.number_of_female).to eq(1)
      expect(sc.number_of_youth).to eq(1)
      expect(sc.number_of_disability).to eq(1)
      expect(sc.number_of_ethnic_minority).to eq(1)
      expect(sc.number_of_id_poor).to eq(1)

      participant.destroy

      sc = scorecard.reload
      expect(sc.number_of_participant).to eq(0)
      expect(sc.number_of_female).to eq(0)
      expect(sc.number_of_youth).to eq(0)
      expect(sc.number_of_disability).to eq(0)
      expect(sc.number_of_ethnic_minority).to eq(0)
      expect(sc.number_of_id_poor).to eq(0)
    end
  end
end
