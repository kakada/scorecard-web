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
require "rails_helper"

RSpec.describe Jaap, type: :model do
  it { is_expected.to validate_presence_of(:province_id) }
  
  describe "data field" do
    it "has default structure" do
      jaap = Jaap.create(province_id: "01")
      expect(jaap.data).to eq({ "columns" => [], "rows" => [] })
    end
    
    it "can store columns and rows" do
      jaap = Jaap.create(
        province_id: "01",
        data: {
          columns: [{ title: "Activity", field: "activity" }],
          rows: [{ activity: "Test Activity" }]
        }
      )
      expect(jaap.data["columns"]).to be_present
      expect(jaap.data["rows"]).to be_present
    end
  end
end
