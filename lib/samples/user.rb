# frozen_string_literal: true

module Samples
  class User
    def self.load(program_name = "ISAF-II")
      program = ::Program.find_by name: program_name
      return if program.nil?
      lngo = program.local_ngos.first

      users = [
        { email: "admin@program.org", role: :program_admin, program_id: program.id },
        { email: "staff@care.org", role: :staff, program_id: program.id  },
        { email: "lngo@care.org", role: :lngo, program_id: program.id, local_ngo_id: lngo.id },
      ]

      users.each do |user|
        u = ::User.new(user.merge({ password: "123456" }))
        u.confirm
      end
    end
  end
end
