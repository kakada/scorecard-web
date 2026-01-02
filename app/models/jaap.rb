# frozen_string_literal: true

# == Schema Information
#
# Table name: jaaps
#
#  id           :bigint           not null, primary key
#  province_id  :string
#  district_id  :string
#  commune_id   :string
#  data         :jsonb            default({"columns"=>[], "rows"=>[]})
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Jaap < ApplicationRecord
  validates :province_id, presence: true
end
