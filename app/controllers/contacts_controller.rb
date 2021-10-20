# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, only: [:edit, :update, :destroy]

  def index
    @contacts = authorize Contact.no_program
  end

  def new
    @contact = authorize Contact.new
  end

  def create
    @contact = authorize Contact.new contact_params
    if @contact.save
      redirect_to system_contacts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    authorize @contact
    if @contact.update(contact_params)
      redirect_to system_contacts_path
    else
      render :edit
    end
  end

  def destroy
    authorize @contact.destroy
    redirect_to system_contacts_path
  end

  private
    def set_contact
      @contact = Contact.find params[:id]
    end

    def contact_params
      params.require(:contact).permit(:contact_type, :value)
    end
end
