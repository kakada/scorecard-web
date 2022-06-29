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
require 'rails_helper'

RSpec.describe Thematic, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  describe "before_create .secure_code" do
    context "has code" do
      let(:thematic) { create(:thematic, code: '123') }

      it { expect(thematic.code).to eq('123') }
    end

    context "no code" do
      let(:thematic) { create(:thematic, code: nil) }

      it { expect(thematic.code).not_to be_nil }
    end
  end
end
