# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  prepend_before_action :register_signout_activity, only: :destroy
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  private
    def register_signout_activity
      ActiveSupport::Notifications.instrument ActivityLog.signout_activity, signout_params
    end

    def signout_params
      {
        "controller"  => controller_name,
        "action"      => action_name,
        "format"      => request_format,
        "method"      => request.request_method,
        "path"        => request.fullpath,
        "status"      => status,
        "remote_ip"   => request.remote_ip,
        "current_user_id" => current_user&.id
      }.with_indifferent_access
  end

    def check_captcha
      return if Rails.env.development? || verify_recaptcha # verify_recaptcha(action: 'login') for v3

      self.resource = resource_class.new sign_in_params

      respond_with_navigational(resource) do
        flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
        render :new
      end
    end
end
