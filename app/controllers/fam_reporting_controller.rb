# frozen_string_literal: true

class FamReportingController < ApplicationController
  skip_before_action :authenticate_user!
  layout :set_layout

  def show
    ahoy.track "view_fam_reporting"
  end

  private
    def set_layout
      signed_in? ? "layouts/application" : "layouts/footer_less"
    end
end
