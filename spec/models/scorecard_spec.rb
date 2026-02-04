# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                          :bigint           not null, primary key
#  uuid                        :string
#  unit_type_id                :integer
#  facility_id                 :integer
#  name                        :string
#  description                 :text
#  province_id                 :string(2)
#  district_id                 :string(4)
#  commune_id                  :string(6)
#  year                        :integer
#  conducted_date              :datetime
#  number_of_caf               :integer
#  number_of_participant       :integer
#  number_of_female            :integer
#  planned_start_date          :datetime
#  planned_end_date            :datetime
#  status                      :integer
#  program_id                  :integer
#  local_ngo_id                :integer
#  scorecard_type              :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  location_code               :string
#  number_of_disability        :integer
#  number_of_ethnic_minority   :integer
#  number_of_youth             :integer
#  number_of_id_poor           :integer
#  creator_id                  :integer
#  locked_at                   :datetime
#  primary_school_code         :string
#  downloaded_count            :integer          default(0)
#  progress                    :integer
#  language_conducted_code     :string
#  finished_date               :datetime
#  running_date                :datetime
#  deleted_at                  :datetime
#  published                   :boolean          default(FALSE)
#  device_type                 :string
#  submitted_at                :datetime
#  completed_at                :datetime
#  device_token                :string
#  completor_id                :integer
#  proposed_indicator_method   :integer          default("participant_based")
#  scorecard_batch_code        :string
#  number_of_anonymous         :integer
#  device_id                   :string
#  submitter_id                :integer
#  dataset_id                  :uuid
#  removing_scorecard_batch_id :uuid
#  runner_id                   :integer
#  app_version                 :integer
#  running_mode                :integer          default("online")
#  qr_code                     :string
#  token                       :string(64)
#
require "rails_helper"

RSpec.describe Scorecard, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator).class_name("User") }
  it { is_expected.to belong_to(:completor).class_name("User").optional }
  it { is_expected.to belong_to(:local_ngo).optional }
  it { is_expected.to belong_to(:unit_type).class_name("Facility") }
  it { is_expected.to belong_to(:facility) }
  it { is_expected.to belong_to(:location).optional }
  it { is_expected.to belong_to(:dataset).optional }
  it { is_expected.to belong_to(:primary_school).optional }

  it { is_expected.to have_many(:facilitators) }
  it { is_expected.to have_many(:cafs).through(:facilitators) }
  it { is_expected.to have_many(:participants) }
  it { is_expected.to have_many(:custom_indicators) }
  it { is_expected.to have_many(:raised_indicators) }
  it { is_expected.to have_many(:voting_indicators) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:unit_type_id) }
  it { is_expected.to validate_presence_of(:facility_id) }
  it { is_expected.to validate_presence_of(:province_id) }
  it { is_expected.to validate_presence_of(:district_id) }
  it { is_expected.to validate_presence_of(:commune_id) }
  it { is_expected.to validate_presence_of(:planned_start_date) }
  it { is_expected.to validate_presence_of(:planned_end_date) }

  describe "#validate submitter" do
    context "no submitted_at" do
      let(:scorecard) { build(:scorecard, submitted_at: nil, submitter_id: nil) }

      it { expect(scorecard.valid?).to be_truthy }
    end

    context "has submitted_at" do
      let(:scorecard) { build(:scorecard, submitted_at: Time.now.utc, submitter_id: nil) }

      it { expect(scorecard.valid?).to be_falsey }

      it "requires submitter_id to be presence" do
        scorecard.valid?
        expect(scorecard.errors.messages[:submitter_id]).not_to be_nil
      end
    end
  end

  describe "#validate completor" do
    context "no completed_at" do
      let(:scorecard) { build(:scorecard, completed_at: nil, completor_id: nil) }

      it { expect(scorecard.valid?).to be_truthy }
    end

    context "has completed_at" do
      let(:scorecard) { build(:scorecard, completed_at: Time.now.utc, completor_id: nil) }

      it { expect(scorecard.valid?).to be_falsey }

      it "requires completor_id to be presence" do
        scorecard.valid?
        expect(scorecard.errors.messages[:completor_id]).not_to be_nil
      end
    end
  end

  describe "#secure_uuid" do
    let!(:uuid) { SecureRandom.random_number(1..999999).to_s.rjust(6, "0") }
    let!(:scorecard1) { create(:scorecard, uuid: uuid) }
    let!(:scorecard2) { create(:scorecard, uuid: uuid) }

    it "generates uuid with 6 digits" do
      expect(scorecard2.uuid.length).to eq(6)
    end

    context "ensure unique uuid" do
      it { expect(scorecard2.uuid).not_to eq(uuid) }
    end
  end

  describe "validate #locked_scorecard" do
    let!(:scorecard) { create(:scorecard, :completed) }

    it { expect(scorecard.update(name: "test")).to be_falsey }

    it "raises is locked error" do
      scorecard.update(name: "test")
      expect(scorecard.errors[:base]).to eq([I18n.t("scorecard.record_is_locked")])
    end
  end

  describe "#lock_access!" do
    let!(:scorecard) { create(:scorecard) }
    before { scorecard.lock_access! }

    it { expect(scorecard.completed_at).not_to be_nil }
  end

  describe "#unlock_access!" do
    let!(:scorecard) { create(:scorecard, :submitted, :completed) }

    before { scorecard.unlock_access! }

    it { expect(scorecard.completed_at).to be_nil }
    it { expect(scorecard.update(name: "test")).to be_truthy }
  end

  describe "#access_locked?" do
    context "true" do
      let!(:scorecard) { create(:scorecard, :completed) }

      it { expect(scorecard.access_locked?).to be_truthy }
    end

    context "false" do
      let!(:scorecard) { create(:scorecard, completed_at: nil) }

      it { expect(scorecard.access_locked?).to be_falsey }
    end
  end

  describe "validate planned_end_date" do
    let!(:local_ngo) { create(:local_ngo) }

    context "before planned_start_date" do
      let(:scorecard)  { build(:scorecard, local_ngo: local_ngo, planned_start_date: Date.yesterday, planned_end_date: Date.today) }

      it { expect(scorecard.valid?).to be_truthy }
    end

    context "equal to planned_start_date" do
      let(:scorecard)  { build(:scorecard, local_ngo: local_ngo, planned_start_date: Date.today, planned_end_date: Date.today) }

      it { expect(scorecard.valid?).to be_truthy }
    end

    context "after planned_start_date" do
      let(:scorecard)  { build(:scorecard, local_ngo: local_ngo, planned_start_date: Date.tomorrow, planned_end_date: Date.today) }

      it { expect(scorecard.valid?).to be_falsey }

      it "raises errors" do
        scorecard.valid?
        expect(scorecard.errors.include? :planned_end_date)
      end
    end
  end

  describe "#before_save, set published_column" do
    let!(:program)    { create(:program) }
    let!(:scorecard1) { create(:scorecard, program: program, published: false, created_at: Date.yesterday) }
    let(:scorecard2) { create(:scorecard, program: program, published: false, created_at: Date.today) }

    context "program no data_published_option" do
      it { expect(scorecard1.published).to be_falsey }
      it { expect(scorecard2.published).to be_falsey }
    end

    context "program data_published_option is stop_publish_data" do
      before {
        create(:data_publication, published_option: :stop_publish_data, program: program)
      }

      it { expect(scorecard1.published).to be_falsey }
      it { expect(scorecard2.published).to be_falsey }
    end

    context "program data_published_option is publish_all" do
      before {
        create(:data_publication, published_option: :publish_all, program: program)
      }

      it { expect(scorecard1.published).to be_falsey }
      it { expect(scorecard2.published).to be_truthy }
    end

    context "program data_published_option is publish_from_today" do
      before {
        create(:data_publication, published_option: :publish_from_today, program: program)
      }

      it { expect(scorecard1.reload.published).to be_falsey }
      it { expect(scorecard2.reload.published).to be_truthy }
    end
  end

  describe "#after_commit on update, #create_submitted_progress" do
    let!(:scorecard) { create(:scorecard) }
    let!(:submitter) { scorecard.creator }

    it { expect { scorecard.update(progress: :in_review, submitter: submitter) }.to change { scorecard.scorecard_progresses.count }.by 1 }

    it "creates scorecard in_review progress" do
      scorecard.update(progress: :in_review, submitter: submitter)
      expect(scorecard.scorecard_progresses.last.status).to eq("in_review")
    end
  end

  describe "#after_commit on update, #create_completed_progress" do
    let!(:scorecard) { create(:scorecard, :submitted) }
    let!(:completor) { scorecard.creator }

    it { expect { scorecard.update(progress: :completed, completor: completor) }.to change { scorecard.scorecard_progresses.count }.by 1 }

    it "creates scorecard completed progress" do
      scorecard.update(progress: :completed, completor: completor)
      expect(scorecard.scorecard_progresses.last.status).to eq("completed")
    end
  end

  describe "#before_save, set_primary_school_code" do
    context "no dataset_id" do
      subject { build(:scorecard, dataset_id: nil) }

      it "doesn't set primary_school" do
        subject.save

        expect(subject.primary_school_code).to be_nil
      end
    end

    context "has dataset_id but facility category is not a primary school" do
      let!(:category) { create(:category, :health_center) }
      let!(:dataset) { create(:dataset, category: category, code: "171405_1", name_en: "Toul", name_km: "Toul", commune_id: "171405", district_id: "1714", province_id: "17") }

      subject { build(:scorecard, dataset_id: dataset.id) }

      it "doesn't set primary_school" do
        subject.save

        expect(subject.primary_school_code).to be_nil
      end
    end

    context "has dataset_id and facility category is a primary school" do
      let!(:category) { create(:category) }
      let!(:dataset) { create(:dataset, category: category, code: "171405_1", name_en: "Toul", name_km: "Toul", commune_id: "171405", district_id: "1714", province_id: "17") }
      let!(:primary_school) { create(:primary_school, code: dataset.code) }
      let!(:facility) { create(:facility, :with_parent, category: dataset.category) }

      subject { build(:scorecard, dataset_id: dataset.id, facility: facility, unit_type: facility.parent) }

      it "doesn't set primary_school" do
        subject.save

        expect(subject.primary_school_code).to eq(primary_school.id.to_s)
      end
    end
  end

  describe "#before_save, clear_dataset_id" do
    let!(:category) { create(:category) }
    let!(:dataset) { create(:dataset, category: category, code: "171405_1", name_en: "Toul", name_km: "Toul", commune_id: "171405", district_id: "1714", province_id: "17") }
    let!(:primary_school) { create(:primary_school, code: dataset.code) }
    let!(:facility) { create(:facility, :with_parent, category: dataset.category) }

    subject { create(:scorecard, dataset_id: dataset.id, facility: facility, unit_type: facility.parent) }

    before {
      facility.update(category_id: nil)
      subject.save
    }

    it "doesn't set primary_school" do
      expect(subject.dataset_id).to be_nil
    end
  end

  describe "#running_mode enum" do
    it "defines offline mode" do
      expect(Scorecard.running_modes[:offline]).to eq(0)
    end

    it "defines online mode" do
      expect(Scorecard.running_modes[:online]).to eq(1)
    end

    context "with offline running_mode" do
      let(:scorecard) { build(:scorecard, running_mode: :offline) }

      it "is valid" do
        expect(scorecard.valid?).to be_truthy
      end

      it "has offline running_mode" do
        expect(scorecard.running_mode).to eq("offline")
      end
    end

    context "with online running_mode" do
      let(:scorecard) { build(:scorecard, running_mode: :online) }

      it "is valid" do
        expect(scorecard.valid?).to be_truthy
      end

      it "has online running_mode" do
        expect(scorecard.running_mode).to eq("online")
      end
    end
  end

  describe "raised_participants" do
    it "returns distinct participants from raised_indicators" do
      scorecard = create(:scorecard)
      p1 = create(:participant, scorecard: scorecard)
      p2 = create(:participant, scorecard: scorecard)

      create(:raised_indicator, scorecard: scorecard, participant: p1)
      create(:raised_indicator, scorecard: scorecard, participant: p1) # duplicate
      create(:raised_indicator, scorecard: scorecard, participant: p2)

      expect(scorecard.raised_participants).to match_array([p1, p2])
    end
  end

  describe "rating_participants" do
    it "returns distinct participants from ratings" do
      scorecard = create(:scorecard)
      p1 = create(:participant, scorecard: scorecard)
      p2 = create(:participant, scorecard: scorecard)

      create(:rating, scorecard: scorecard, participant: p1)
      create(:rating, scorecard: scorecard, participant: p1) # duplicate
      create(:rating, scorecard: scorecard, participant: p2)

      expect(scorecard.rating_participants).to match_array([p1, p2])
    end
  end
end
