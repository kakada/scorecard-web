# == Schema Information
#
# Table name: languages_indicators
#
#  id            :bigint           not null, primary key
#  language_id   :integer
#  language_code :string
#  indicator_id  :integer
#  content       :string
#  audio         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class LanguagesIndicator < ApplicationRecord
  belongs_to :language
  belongs_to :indicator

  mount_uploader :audio, AudioUploader

  validates :content, presence: true
end
