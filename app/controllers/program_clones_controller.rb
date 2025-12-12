# frozen_string_literal: true

class ProgramClonesController < ApplicationController
  before_action :set_program

  def show
    @program_clone = authorize ProgramClone.find(params[:id])
  end

  private
    def set_program
      @program = authorize Program.find(params[:program_id])
    end
end
