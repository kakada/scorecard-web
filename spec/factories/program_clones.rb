# frozen_string_literal: true

# == Schema Information
#
# Table name: program_clones
#
#  id                  :bigint           not null, primary key
#  source_program_id   :bigint
#  target_program_id   :bigint           not null
#  user_id             :bigint           not null
#  selected_components :text             default([]), is an Array
#  clone_method        :string           not null
#  status              :integer          default("pending")
#  error_message       :text
#  completed_at        :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :program_clone do
    association :target_program, factory: :program
    association :user
    clone_method { "sample" }
    selected_components { ["languages", "facilities"] }
    status { "pending" }

    trait :from_program do
      clone_method { "program" }
      association :source_program, factory: :program
    end

    trait :processing do
      status { "processing" }
    end

    trait :completed do
      status { "completed" }
      completed_at { Time.current }
    end

    trait :failed do
      status { "failed" }
      error_message { "Something went wrong" }
    end

    trait :with_all_components do
      selected_components { ProgramClone::COMPONENTS }
    end
  end
end
