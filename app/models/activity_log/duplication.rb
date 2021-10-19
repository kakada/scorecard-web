module ActivityLog::Duplication
  def log_exists?
    self.class\
      .where(path: path, remote_ip: remote_ip, user: user)
      .where('created_at > ?', loggable_period)
      .exists?
  end

  private

  def loggable_period
    ENV['ACTIVITY_LOGGABLE_PERIODIC_IN_MINUTE'].to_i.minutes.ago
  end

  def last_activity
    self.class.find_by(user: user)
  end
end
