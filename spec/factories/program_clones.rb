# frozen_string_literal: true

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
