# frozen_string_literal: true

# The reason is that we use a sandbox program for the Scorecard Mobile App.
# When the app is reviewed on the Play Store, an account is required to access its features.
# Therefore, we need to provide a sandbox account so reviewers can log in and review the app properly.
module Samples
  class SandboxSeeder
    SANDBOX_NAME = "Sandbox"
    DEMO_CAF_NAMES = %w[Visal Bopha Nary Sokha].freeze
    FACILITY_CODE = "GF" # Garment Factory
    DEFAULT_PASSWORD = ENV.fetch("SANDBOX_DEFAULT_PASSWORD", "123456")
    DEFAULT_SCORECARD_CODE = "000000"

    def load
      ActiveRecord::Base.transaction do
        program   = create_program
        local_ngo = create_local_ngo(program)

        create_cafs(local_ngo)

        admin_user = create_and_confirm_user(
          email: "admin@sandbox.org",
          role: :program_admin,
          program_id: program.id
        )

        create_and_confirm_user(
          email: "lngo@sandbox.org",
          role: :lngo,
          program_id: program.id,
          local_ngo_id: local_ngo.id
        )

        create_sample_scorecard(program, local_ngo, admin_user)
      end
    end

    private
      def create_program
        program = ::Program.find_or_create_by!(
          name: SANDBOX_NAME,
          shortcut_name: SANDBOX_NAME,
          sandbox: true
        )

        ::ProgramScorecardType::TYPES.each do |type|
          ::ProgramScorecardType.find_or_create_by!(type.merge(program_id: program.id))
        end

        # It clones Facilities, Inidicator, Language, PDF template, and Rating Scale
        ProgramService.new(program.id).clone_from_sample if program.previous_changes.key?("id")
        program
      end

      def create_local_ngo(program)
        lngo = ::LocalNgo.find_or_initialize_by(
          name: SANDBOX_NAME,
          program_id: program.id
        ) do |ngo|
          ngo.target_province_ids = "01"
        end

        lngo.save!
        lngo
      end

      def create_cafs(local_ngo)
        DEMO_CAF_NAMES.each do |name|
          ::Caf.find_or_create_by!(
            name: name,
            local_ngo_id: local_ngo.id
          )
        end
      end

      def create_and_confirm_user(email:, role:, program_id:, local_ngo_id: nil)
        user = ::User.find_or_initialize_by(email: email)

        user.assign_attributes(
          role: role,
          password: DEFAULT_PASSWORD,
          program_id: program_id,
          local_ngo_id: local_ngo_id
        )

        user.save!
        user.confirm unless user.confirmed?
        user
      end

      # The sample scorecard behaves like other scorecards.
      # The difference is that when the mobile app submits the scorecard,
      # it ignores updating the scorecard itself.
      def create_sample_scorecard(program, local_ngo, admin_user)
        facility = program.facilities.find_by!(code: FACILITY_CODE)
        category = facility.category
        raise "Facility '#{facility.name_en}' must have a category with datasets." unless category&.datasets&.any?

        dataset = category.datasets.sample

        ::Scorecard.find_or_create_by!(uuid: DEFAULT_SCORECARD_CODE) do |scorecard|
          scorecard.program_id     = program.id
          scorecard.conducted_date = Date.current
          scorecard.year           = Date.current.year
          scorecard.province_id    = dataset.province_id
          scorecard.district_id    = dataset.district_id
          scorecard.commune_id     = dataset.commune_id
          scorecard.dataset_id     = dataset.id
          scorecard.unit_type_id   = facility.parent_id
          scorecard.facility_id    = facility.id
          scorecard.local_ngo_id   = local_ngo.id
          scorecard.scorecard_type = ::Scorecard.scorecard_types.keys.sample
          scorecard.creator_id     = admin_user.id
          scorecard.planned_start_date = Date.tomorrow
          scorecard.planned_end_date = Date.tomorrow
        end
      end
  end
end
