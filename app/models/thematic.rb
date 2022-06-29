# == Schema Information
#
# Table name: thematics
#
#  id          :uuid             not null, primary key
#  code        :string
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Thematic < ApplicationRecord
  has_many :indicators

  validates :name, presence: true
  validates :code, uniqueness: true, allow_nil: true

  before_create :secure_code

  private
    def secure_code
      self.code ||= "thematic_#{SecureRandom.uuid[0..3]}"

      return unless self.class.exists?(code: code)

      self.code = "thematic_#{SecureRandom.uuid[0..3]}"
      secure_code
    end
end
