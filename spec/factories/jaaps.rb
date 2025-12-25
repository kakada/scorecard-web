# frozen_string_literal: true

# == Schema Information
#
# Table name: jaaps
#
#  id                :bigint           not null, primary key
#  title             :string
#  description       :text
#  uuid              :string           not null
#  program_id        :bigint
#  scorecard_id      :string
#  user_id           :bigint
#  field_definitions :jsonb            default([])
#  rows_data         :jsonb            default([])
#  completed_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :jaap do
    title { "Action Plan #{FFaker::Lorem.word}" }
    description { FFaker::Lorem.sentence }
    association :program
    association :user
    field_definitions { Jaap.default_field_definitions }
    rows_data {
      [
        {
          'issue' => 'Test issue',
          'root_cause' => 'Test root cause',
          'action' => 'Test action',
          'responsible_person' => 'John Doe',
          'deadline' => '2024-12-31',
          'budget' => '1000',
          'status' => 'Not Started'
        }
      ]
    }

    trait :completed do
      completed_at { Time.current }
    end

    trait :with_scorecard do
      association :scorecard
    end

    trait :with_multiple_rows do
      rows_data {
        [
          {
            'issue' => 'Issue 1',
            'root_cause' => 'Root cause 1',
            'action' => 'Action 1',
            'responsible_person' => 'Person 1',
            'deadline' => '2024-12-31',
            'budget' => '1000',
            'status' => 'Not Started'
          },
          {
            'issue' => 'Issue 2',
            'root_cause' => 'Root cause 2',
            'action' => 'Action 2',
            'responsible_person' => 'Person 2',
            'deadline' => '2025-01-15',
            'budget' => '2000',
            'status' => 'In Progress'
          }
        ]
      }
    end
  end
end
