# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout :set_layout

  def show
    @static_page = StaticPage.find_by!(slug: params[:slug])

    ahoy.track @static_page.event_name
  end

  private
    def set_layout
      signed_in? ? "layouts/application" : "layouts/footer_less"
    end
end
