# frozen_string_literal: true

module Sample
  class User
    def self.load
      care = ::Program.find_by name: "CARE"
      lngo = care.local_ngos.first

      users = [
        { email: "care@program.org", role: :program_admin, program_id: care.id },
        { email: "staff@care.org", role: :staff, program_id: care.id  },
        { email: "lngo@care.org", role: :lngo, program_id: care.id, local_ngo_id: lngo.id },
      ]

      users.each do |user|
        u = ::User.new(user.merge({ password: "123456" }))
        u.confirm
      end
    end
  end
end
