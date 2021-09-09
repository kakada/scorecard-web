class LocalNgoService
  attr_reader :program

  def initialize(program_id)
    @program = Program.find(program_id)
  end

  def migrate_self_and_dependency
    csv = CSV.read(file_path("migrating_local_ngo.csv"))
    csv.shift
    csv.each do |row|
      local_ngo = LocalNgo.find_by name: row[0]
      next if local_ngo.nil? || program.name != row[1]

      local_ngo.update(program_id: program.id)

      migrate_local_ngo_users(local_ngo, program)
      migrate_scorecards(local_ngo, program)
    end
  end

  private
    def migrate_local_ngo_users(local_ngo, program)
      local_ngo.users.each do |user|
        user.update(program_id: program.id)
      end
    end

    def migrate_scorecards(local_ngo, program)
      local_ngo.scorecards.each do |scorecard|
        update_scorecard(scorecard, program)
        migrate_voting_indicators(scorecard)
        migrate_voting_indicators(scorecard)
      end
    end

    def update_scorecard(scorecard, program)
      facility = program.facilities.find_by code: scorecard.facility.code
      scorecard.program_id = program.id
      scorecard.facility_id = facility.id
      scorecard.unit_type_id = facility.parent_id
      scorecard.save(validate: false)
    end

    def migrate_voting_indicators(scorecard)
      scorecard.voting_indicators.each do |indi|
        update_indicatorable(scorecard, indi)
      end
    end

    def migrate_raised_indicators(scorecard)
      scorecard.raised_indicators.each do |indi|
        update_indicatorable(scorecard, indi)
      end
    end

    def update_indicatorable(scorecard, indi)
      return if indi.indicatorable_type == "CustomIndicator"

      indicator = scorecard.facility.indicators.find_by name: indi.indicatorable.name
      indi.update(indicatorable_id: indicator.id)
    end

    def file_path(file_name)
      file_path = Rails.root.join("lib", "scorecard_criteria", "assets", "csv", file_name).to_s
      return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)
      file_path
    end
end
