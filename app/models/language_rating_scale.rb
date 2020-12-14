# frozen_string_literal: true

# == Schema Information
#
# Table name: language_rating_scales
#
#  id              :bigint           not null, primary key
#  rating_scale_id :integer
#  language_id     :integer
#  language_code   :string
#  audio           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class LanguageRatingScale < ApplicationRecord
  include Audio

  belongs_to :language
  belongs_to :rating_scale
end
