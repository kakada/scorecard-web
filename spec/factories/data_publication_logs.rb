# == Schema Information
#
# Table name: data_publication_logs
#
#  id               :uuid             not null, primary key
#  program_id       :integer
#  published_option :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :data_publication_log do
    
  end
end
