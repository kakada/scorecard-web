# == Schema Information
#
# Table name: indicators
#
#  id          :bigint           not null, primary key
#  category_id :integer
#  tag         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Indicator, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
