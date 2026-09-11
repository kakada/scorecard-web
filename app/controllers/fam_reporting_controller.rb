# frozen_string_literal: true

class FamReportingController < ApplicationController
  skip_before_action :authenticate_user!
  layout :set_layout

  def show
    @content = StaticPage.find_by(slug: "/fam_reporting")&.content_by_locale(I18n.locale)
    ahoy.track "view_fam_reporting"
  end

  private
    def set_layout
      signed_in? ? "layouts/application" : "layouts/footer_less"
    end
end
