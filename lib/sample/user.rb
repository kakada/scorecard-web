# frozen_string_literal: true

module Sample
  class User
    def self.load
      care = ::Program.find_by name: "CARE"

      users = [
        { email: "care@program.org", role: :program_admin, program_id: care.id },
        { email: "staff@care.org", role: :staff, program_id: care.id  },
        { email: "guest@care.org", role: :guest, program_id: care.id },
      ]

      users.each do |user|
        u = ::User.new(user.merge({ password: "123456" }))
        u.confirm
      end
    end
  end
end
