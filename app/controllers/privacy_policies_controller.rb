# frozen_string_literal: true

class PrivacyPoliciesController < ApplicationController
  skip_before_action :authenticate_user!
  layout :set_layout

  def show
  end

  private
    def set_layout
      signed_in? ? "layouts/application" : "layouts/footer_less"
    end
end
