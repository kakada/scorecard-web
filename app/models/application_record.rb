# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  strip_attributes

  def secure_uuid
    self.uuid ||= SecureRandom.uuid

    return unless self.class.exists?(uuid: uuid)

    self.uuid = SecureRandom.uuid
    secure_uuid
  end
end
