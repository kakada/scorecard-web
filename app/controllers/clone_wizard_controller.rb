# frozen_string_literal: true

class CloneWizardController < ApplicationController
  STEPS = %i[select_method choose_component review].freeze

  before_action :set_program
  before_action :validate_step
  before_action :init_service

  def show
    @wizard_service.wizard.clear if params[:restart].present?

    render template_for(@step)
  end

  def update
    handler = "update_#{@step}"
    return head :bad_request unless respond_to?(handler, true)

    send(handler)
  end

  private
    def update_select_method
      if @wizard_service.valid_select_method?(params)
        redirect_to next_step_path(:choose_component)
      else
        flash.now[:alert] = t("program_clone.failed_to_select_method")
        render template_for(:select_method)
      end
    end

    def update_choose_component
      components = params.dig(:program_clone, :selected_components)

      unless @wizard_service.valid_choose_components?(components)
        flash.now[:alert] = t("program_clone.please_select_components")
        return render template_for(:choose_component)
      end

      redirect_to next_step_path(:review)
    end

    def update_review
      if @wizard_service.save_program_clone
        redirect_to program_program_clone_path(@program, @wizard_service.program_clone),
                    notice: t("program_clone.started_successfully")
      else
        flash.now[:alert] = @wizard_service.program_clone.errors.full_messages.join(", ")
        render template_for(:review)
      end
    end

    # -----------------------------------
    # utilities
    # -----------------------------------

    def template_for(step)
      "clone_wizard/#{step}"
    end

    def next_step_path(step)
      clone_wizard_program_step_path(@program, step)
    end

    def set_program
      @program = authorize Program.find(params[:program_id])
    end

    def validate_step
      @step = params[:step]&.to_sym

      return if STEPS.include?(@step)

      redirect_to clone_wizard_program_step_path(@program, :select_method)
    end

    def init_service
      @wizard_service = ProgramCloneWizardService.new(@program, current_user, session)
      @program_clone = @wizard_service.program_clone
    end
end
