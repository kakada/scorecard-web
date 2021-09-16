require "rails_helper"

RSpec.describe Api::V1::ContactsController, type: :controller do
  describe "system contact" do
    context "with system email" do
      let!(:contact) { create(:contact, :no_program, :system_email) }

      it "responses system email as json" do
        get :index

        expect(response.body).to include 'email@system.com'
      end
    end

    context "with system tel" do
      let!(:contact) { create(:contact, :no_program, :system_tel) }

      it "responses system tel as json" do
        get :index

        expect(response.body).to include '012333444'
      end
    end
  end

  describe "program contact" do
    let(:contact) { create(:contact) }
    let(:program) { create(:program, contacts: [contact]) }
    let!(:user) { create(:user, program: program) }

    before do
      request.headers['Authorization'] = "Token #{user.authentication_token}"
    end

    it "returns program contact" do
      get :index

      expect(response.body).to include contact.value
    end
  end
end
