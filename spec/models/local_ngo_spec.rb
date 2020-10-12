require 'rails_helper'

RSpec.describe LocalNgo, type: :model do
  it { is_expected.to belong_to(:program) }
  it { is_expected.to have_many(:cafs) }
end
