# == Schema Information
#
# Table name: indicators
#
#  id                 :bigint           not null, primary key
#  categorizable_id   :integer
#  categorizable_type :string
#  tag                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :indicator do
    
  end
end
