module ActivityLog::Duplication
  def duplicate?
    same_http_method? && same_path? && invalid_period?
  end

  private

  def same_http_method?
    http_method.downcase == 'get' && last_activity.http_method.downcase == 'get'
  end

  def same_path?
    last_activity.path.to_s.downcase == path.to_s.downcase
  end

  def invalid_period?
    last_activity.created_at > loggable_period
  end

  def loggable_period
    period = ENV['ACTIVITY_LOGGABLE_PERIODIC_IN_MINUTE'] || default_loggable_period
    period.to_i.minutes.ago
  end

  def default_loggable_period
    5
  end

  def last_activity
    self.class.find_by(user: user)
  end
end
