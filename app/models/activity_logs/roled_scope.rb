# frozen_string_literal: true

module ActivityLogs::RoledScope
  def system_admin(args)
    all
  end

  def program_admin(args)
    where(program_id: args[:program_id])
  end

  def staff(args)
    where(user_id: args[:user_id], program_id: args[:program_id])
  end

  alias_method :lngo, :staff
end
