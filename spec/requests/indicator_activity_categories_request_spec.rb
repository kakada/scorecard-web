# frozen_string_literal: true

require "rails_helper"

RSpec.describe "IndicatorActivityCategories", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:program) { create(:program) }
  let(:program_admin) { create(:user, :program_admin, program: program) }

  describe "DELETE /indicator_activity_categories/:id" do
    before { sign_in program_admin }

    it "does not delete a category when it is already used" do
      category = create(:indicator_activity_category, program: program)
      create(:suggested_indicator_activity, indicator_activity_category: category)

      expect do
        delete indicator_activity_category_path(category)
      end.not_to change(IndicatorActivityCategory, :count)

      expect(response).to redirect_to(indicator_activity_categories_path)
      expect(flash[:alert]).to eq(I18n.t("indicator_activity_category.already_in_use"))
    end
  end

  describe "PATCH /indicator_activity_categories/:id/move" do
    before { sign_in program_admin }

    it "moves a category up" do
      first = create(:indicator_activity_category, program: program, display_order: 1)
      second = create(:indicator_activity_category, program: program, display_order: 2)

      patch move_indicator_activity_category_path(second, direction: "up")

      expect(response).to redirect_to(indicator_activity_categories_path)
      expect(first.reload.display_order).to eq(2)
      expect(second.reload.display_order).to eq(1)
    end

    it "moves a category down" do
      first = create(:indicator_activity_category, program: program, display_order: 1)
      second = create(:indicator_activity_category, program: program, display_order: 2)

      patch move_indicator_activity_category_path(first, direction: "down")

      expect(response).to redirect_to(indicator_activity_categories_path)
      expect(first.reload.display_order).to eq(2)
      expect(second.reload.display_order).to eq(1)
    end

    it "shows error when direction is invalid" do
      category = create(:indicator_activity_category, program: program, display_order: 1)

      patch move_indicator_activity_category_path(category, direction: "left")

      expect(response).to redirect_to(indicator_activity_categories_path)
      expect(flash[:alert]).to eq(I18n.t("indicator_activity_category.invalid_direction"))
    end

    it "keeps ordering when moving the first category up" do
      first = create(:indicator_activity_category, program: program, display_order: 1)
      second = create(:indicator_activity_category, program: program, display_order: 2)

      patch move_indicator_activity_category_path(first, direction: "up")

      expect(first.reload.display_order).to eq(1)
      expect(second.reload.display_order).to eq(2)
    end

    it "keeps ordering when moving the last category down" do
      first = create(:indicator_activity_category, program: program, display_order: 1)
      second = create(:indicator_activity_category, program: program, display_order: 2)

      patch move_indicator_activity_category_path(second, direction: "down")

      expect(first.reload.display_order).to eq(1)
      expect(second.reload.display_order).to eq(2)
    end
  end
end
