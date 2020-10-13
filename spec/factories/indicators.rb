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
FactoryBot.define do
  factory :indicator do
    
  end
end
