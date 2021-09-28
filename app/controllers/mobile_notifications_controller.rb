# frozen_string_literal: true

class MobileNotificationsController < ApplicationController
  def index
    @pagy, @notifications = pagy(authorize policy_scope(MobileNotification.order("updated_at DESC")))
  end

  def new
    @notification = authorize MobileNotification.new
  end

  def create
    @notification = authorize MobileNotification.new(notification_params)

    if @notification.save
      redirect_to mobile_notifications_url
    else
      render :new
    end
  end

  private
    def notification_params
      params.require(:mobile_notification).permit(
        :id, :title, :body, :success_count, :failure_count
      ).merge(
        creator_id: current_user.id,
        program_id: current_user.program_id,
        program_uuid: current_user.program_uuid
      )
    end
end
