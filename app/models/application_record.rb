# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  strip_attributes

  def secure_uuid
    self.uuid ||= SecureRandom.uuid

    return unless self.class.exists?(uuid: uuid)

    self.uuid = SecureRandom.uuid
    secure_uuid
  end

  def secure_code
    self.code ||= SecureRandom.uuid[0..5]

    return unless self.class.exists?(code: code)

    self.code = SecureRandom.uuid[0..5]
    secure_code
  end
end
