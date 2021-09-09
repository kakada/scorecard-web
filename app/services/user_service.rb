class UserService
  attr_reader :program

  def initialize(program_id)
    @program = Program.find(program_id)
  end

  def migrate_program
    csv = CSV.read(file_path("migrating_user.csv"))
    csv.shift
    csv.each do |row|
      user = User.find_by email: row[0]
      next if user.nil? || program.name != row[1]

      user.update(program_id: program.id)
    end
  end

  private
    def file_path(file_name)
      file_path = Rails.root.join("lib", "scorecard_criteria", "assets", "csv", file_name).to_s
      return puts "Fail to import data. could not find #{file_path}" unless File.file?(file_path)
      file_path
    end
end
