# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend
  include SortOrder

  helper_method :sort_column, :sort_direction

  protect_from_forgery prepend: true

  before_action :authenticate_user!
  before_action :set_raven_context
  before_action :set_locale

  layout :set_layout

  def current_program
    @current_program ||= current_user.try(:program)
  end
  helper_method :current_program

  private
    def set_layout
      devise_controller? ? "layouts/minimal" : "layouts/application"
    end

    def set_raven_context
      Raven.user_context(id: session[:current_user_id]) # or anything else in session
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end

    def set_locale
      I18n.locale = current_user.try(:language_code) || I18n.default_locale
    end
end
