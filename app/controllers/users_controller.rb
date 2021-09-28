# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @pagy, @users = pagy(policy_scope(authorize User.filter(params).order(sort_column + " " + sort_direction).includes(:program)))
  end

  def new
    @user = authorize User.new
  end

  def create
    @user = authorize User.new(user_params)

    if @user.save
      redirect_to users_url
    else
      flash.now[:alert] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = authorize User.find(params[:id])
  end

  def update
    @user = authorize User.find(params[:id])

    if @user.update(user_params)
      redirect_to users_url
    else
      flash.now[:alert] = @user.errors.full_messages
      render :edit
    end
  end

  def archive
    @user = authorize User.find(params[:id])
    @user.destroy

    redirect_to users_url, notice: I18n.t("user.archive_successfully", email: @user.email)
  end

  def restore
    @user = authorize User.only_deleted.find(params[:id])
    @user.restore

    redirect_to users_url, notice: I18n.t("user.restore_successfully", email: @user.email)
  end

  def destroy
    @user = authorize User.only_deleted.find(params[:id])
    @user.really_destroy!

    redirect_to users_url(archived: true)
  end

  def update_locale
    current_user.language_code = locale_params[:language_code]
    if current_user.save
      head :ok
    else
      render json: current_user.errors.messages
    end
  end

  def unlock_access
    @user = authorize User.find(params[:id])
    @user.unlock_access!

    redirect_to users_url
  end

  def resend_confirmation
    @user = User.find_by(id: params[:id])
    @user.send_confirmation_instructions

    redirect_to users_url, notice: I18n.t("user.resend_confirmation_successfully")
  end

  private
    def user_params
      params.require(:user).permit(:email, :role, :program_id, :program_uuid, :local_ngo_id, :actived)
    end

    def locale_params
      params.require(:user).permit(:language_code)
    end
end
