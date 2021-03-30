# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_chat_group

  def index
    @messages = current_program.messages
  end

  def new
    @message = current_program.messages.new(milestone: params[:milestone])
    @message.build_telegram_notification
    @message.build_email_notification
  end

  def create
    @message = current_program.messages.new(message_params)

    if @message.save
      redirect_to messages_url
    else
      render :new
    end
  end

  def edit
    @message = current_program.messages.find(params[:id])
    @message.build_telegram_notification if @message.telegram_notification.nil?
    @message.build_email_notification if @message.email_notification.nil?
  end

  def update
    @message = current_program.messages.find(params[:id])

    if @message.update_attributes(message_params)
      redirect_to messages_url
    else
      render :edit
    end
  end

  private
    def message_params
      params.require(:message).permit(:content, :milestone,
        telegram_notification_attributes: [ chat_group_ids: [] ],
        email_notification_attributes: [ :id, :emails ]
      )
    end

    def set_chat_group
      @chat_groups = current_program.chat_groups.telegrams
    end
end
