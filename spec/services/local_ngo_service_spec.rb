# frozen_string_literal: true

require "rails_helper"

RSpec.describe LocalNgoService do
  describe "#clone_from_template" do
    let!(:program)  { create(:program) }
    let(:file)      { Rails.root.join("public", "local_ngos_and_cafs.xlsx").to_s }
    let(:service)   { LocalNgoService.new(program.id) }
    let(:lngo)      { LocalNgo.find_by(code: "lngo0002") }

     before {
       service.import(file)
     }

     it { expect(LocalNgo.count).to eq(2) }
     it { expect(lngo.cafs.count).to eq(3) }
  end
end
