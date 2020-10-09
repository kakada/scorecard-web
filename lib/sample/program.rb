# frozen_string_literal: true

module Sample
  class Program
    def self.load
      u = ::User.new(email: "admin@instedd.org", role: :system_admin, password: "123456", program_id: nil)
      u.confirm

      %w[CARE].each do |program_name|
        ::Program.create(name: program_name)
      end
    end
  end
end
